# Uploading files

A common task is uploading some sort of file, whether it's a picture
of a person or a CSV file containing data to process.

To start, you must specify that the form contains
`multipart/form-data`; this format allows you to mix standard browser
input form data with binary data from files. If you use `form_for`,
this is done automatically. If you use `form_tag`, you must set it
yourself, as per the following example.

The following two forms would both upload a file on submission.

```erb
<%= form_tag(secret(@secret, :method => :post), :multipart => true) do %>
  <%= file_field_tag :photo %>
  
  <!-- ... -->
<% end %>

<%= form_for @secret do |f| %>
  <%= f.file_field :photo %>
  
  <!-- ... -->
<% end %>
```

Rails provides the usual pair of helpers: the bare-bones
`file_field_tag` and the model oriented `file_field`. As you would
expect, in the first case the uploaded file is in `params[:photo]` and
in the second case in `params[:secret][:photo]`.

## What gets uploaded

The object in the `params` hash is an instance of a subclass of `IO`:
you can call `#read` on it. The uploaded `IO` object will also have an
`original_filename` attribute containing the name the file had on the
user's computer and a `content_type` attribute containing the MIME
type of the uploaded file.

```ruby
class SecretsController
  def create
    # remove the file parameter
    photo_io = params[:secret].delete(:photo)
    photo_filename = photo_io.original_filename
    photo_blob = photo_io.read
    
    # ...
  end
end
```

## Storing blobs of data on the server

The simplest way to store blobs of data is in your database. To do
this, you can add a `BLOB` column to your table:

```ruby
class AddPhotoToSecrets
  def change
    # :binary is how Rails says BLOB
    add_column :secrets, :photo_blob, :binary
  end
end
```

Then you can upload a photo like so:

```ruby
# app/controllers/secrets_controller.rb
class SecretsController
  def create
    # remove the file parameter and slurp in the data. must remove
    # attribute from params; attached files can't be mass-assigned.
    photo_blob = params[:secret].delete(:photo).read
    
    secret = Secret.new(params[:secret])
    secret.photo_blob = photo_blob
    
    secret.save
    
    redirect_to secret_path(secret)
  end
end
```

Since we are being lazy, we are not storing the content-type of the
file. We'll play fast-and-loose and assume a jpeg has been
uploaded. We would normally want to record the MIME type and also
validate that the data is a valid file of that type.

This is a simple example, but an alternative would be to store the
uploaded file in either Amazon S3 or local storage using a gem called
[carrierwave][carrierwave-github].

[carrierwave]: https://github.com/jnicklas/carrierwave

## Fetching binary data

Now that the data is uploaded, let's add a controller action to fetch
the photo for a `Secret`:

```ruby
# config/routes.rb
resources :secrets do
  # member actions can be called for any secret; this will generate a
  # url like /secrets/1234/photo
  member do
    get "photo"
  end
end
```

This adds a new route:

```
~/SecretApp$ rake routes
photo_secret GET    /secrets/:id/photo(.:format) secrets#photo
     secrets GET    /secrets(.:format)           secrets#index
             POST   /secrets(.:format)           secrets#create
  new_secret GET    /secrets/new(.:format)       secrets#new
 edit_secret GET    /secrets/:id/edit(.:format)  secrets#edit
      secret GET    /secrets/:id(.:format)       secrets#show
             PUT    /secrets/:id(.:format)       secrets#update
             DELETE /secrets/:id(.:format)       secrets#destroy
        root        /                            secrets#index
```

**TODO**: do I want to `member do` here, or just `get "photo"`? This
generates a weird looking route.

We need to add a corresponding controller action:

```ruby
# apps/controllers/secrets_controller.rb
class SecretsController < ApplicationController
  def photo
    secret = Secret.find(params[:secret_id])
    send_data(secret.photo, :type => 'image/jpg', :disposition => 'inline')
  end
end
```

The `send_data` method tells the controller to return binary data to
the client. We specify the type (so that the browser knows it's a
jpeg). The `:disposition` option is set to inline, which means that if
we go to `/secrets/1234/photo` it will display in the browser, vs
downloading it (disposition should be attachment to do that).

Finally, let's update our `SecretsController#show` action:

```html+erb
<!-- app/views/secrets/show.html.erb -->
Secret: <%= @secret.body %>
<br>
<%= image_tag photo_secret_url(@secret) %>
```

This will then create a tag to the image. The browser will fetch the
HTML, and when it sees the `image_tag` will then make a GET request
for the image, too.
