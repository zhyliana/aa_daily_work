# Action Mailer Basics

Action Mailer allows you to send emails from your application. There
are two parts:

* An [`ActionMailer::Base`][action-mailer-base-docs] class. This works
  like a controller. Mailers live in `app/mailers`.
* Views, which live in `app/views/[mailer_name]`.

## Your first mailer
### Generate the Mailer

```bash
$ rails generate mailer UserMailer
create  app/mailers/user_mailer.rb
invoke  erb
create    app/views/user_mailer
invoke  test_unit
create    test/functional/user_mailer_test.rb
```

So we got the mailer, the views, and the tests.

### Edit the mailer

`app/mailers/user_mailer.rb` contains an empty mailer:

```ruby
class UserMailer < ActionMailer::Base
  default from: 'from@example.com'
end
```

Let's add a method called `welcome_email`, that will send an email to
the user's registered email address:

```ruby
class UserMailer < ActionMailer::Base
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end
  
  def reminder_email(user)
    # ...
  end
  
  # other emails...
end
```

Somewhat like a controller, this adds a mailer action that will send a
`welcome_email` to the passed user. We set the `to` and the `subject`
(as well as `from`; which is set from the default above). The content
of the email lives in a view (more in a sec) which will be rendered.

You can also set `cc` and `bcc` attributes. To send to multiple
emails, use an array of email strings.

You can put the name of the recipient in the email address like so:
`"Ned Ruggeri <ned@appacademy.io>"`. This is a nice way of
personalizing your email. Likewise you should personalize the sender:
`"App Academy <contact@appacademy.io>"`.

The `mail` method returns an email object (of type
[`Mail::Message`][mail-message-github]); it doesn't mail it
though. The caller of `UserMailer#welcome_email` will then call
`#deliver` on the `Message` object:

```ruby
u = User.find(123)

msg = UserMailer.welcome_email(u)
msg.deliver
```

### Create a mailer view

Wait. What about the content? Create a file called
`welcome_email.html.erb` in `app/views/user_mailer/`. This will be the
template used for the email, formatted in HTML:

```html+erb
<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <h1>Welcome to example.com, <%= @user.name %></h1>
    <p>
      You have successfully signed up to example.com,
      your username is: <%= @user.login %>.<br/>
    </p>
    <p>
      To login to the site, just follow this link: <%= @url %>.
    </p>
    <p>Thanks for joining and have a great day!</p>
  </body>
</html>
```

Just like controllers, any instance variables we define in the method
become available for use in the views.

It is also a good idea to make a text version for this email. People
who don't like HTML emails should have a text version to look
at. Also, spam filters will ding you if you don't have a text version;
a lot of email gets flagged as spam, so this is a problem.

To do this, create a file called `welcome_email.text.erb` in
`app/views/user_mailer/`:

```erb
Welcome to example.com, <%= @user.name %>
===============================================

You have successfully signed up to example.com,
your username is: <%= @user.login %>.

To login to the site, just follow this link: <%= @url %>.

Thanks for joining and have a great day!
```

When you call the `mail` method now, Action Mailer will detect the two
templates (text and HTML) and automatically generate a
`multipart/alternative` email; the user's email client will be able to
choose between the two formats.

### Mailing is slow

Sending out an email often takes up to 1sec. This is kind of slow. In
particular, if your Rails app is sending a mail as part of a
controller action, the user will have to wait an extra second for the
HTTP response to be sent.

We'll eventually learn how to "batch up" and send emails offline, but
for now just know that if you try to send 100 emails in a controller
method, you're going to have trouble responding to requests promptly.

## Mailing deets

### Adding attachments

Adding attachments is simple:

```ruby
attachments['filename.jpg'] = File.read('/path/to/filename.jpg')
```

### Generating URLs in Action Mailer Views

You will probably want to embed URLs into your mailer views just like
for your controller views. Somewhat oddly, you must set an option in
`config/environments/production.rb` (and
`config/environments/development.rb` for development) so that the
mailer knows the base url of the website:

```ruby
config.action_mailer.default_url_options = { host: 'example.com' }
```

You would think that the Rails app knows the hostname (e.g., it
doesn't need you to set this for `*_url` methods in controller
views). Weird, but whatever.

Make sure to (continue to) use the `*_url` form of the url helpers,
since when the user opens their email, the email needs to contain the
full hostname of the site to know what host to send the request
to. This is because the email is being opened by a mail-client that
isn't on the same domain as your site (e.g., email is opened on
gmail.com, link needs to point to appacademy.io).

### Letter Opener

Testing email sending in development can be a PITA. Use the wonderful
[letter_opener][letter-opener-github] gem. When running the
development environment (your local machine), instead of sending an
email out to the real world, letter\_opener will instead pop open the
"sent" email in the browser.

Setup is two lines:

```ruby
# Gemfile
gem "letter_opener", :group => :development

# config/environments/development.rb
config.action_mailer.delivery_method = :letter_opener
```

## Resources

* [ActionMailer::Base][action-mailer-base-docs]

[action-mailer-base-docs]: http://api.rubyonrails.org/classes/ActionMailer/Base.html
[mail-message-github]: https://github.com/mikel/mail/blob/master/lib/mail/message.rb
[letter-opener-github]: https://github.com/ryanb/letter_opener
