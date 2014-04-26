# Routing II: Nested Collections

## Nested Resource Routes

It's common to have resources that are "children" of other
resources. For example, suppose your application includes these
models:

```ruby
class Magazine < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :magazine
end
```

Nested routes allow you to capture this relationship in your
routing. In this case, you could include this route declaration:

```ruby
NewspapersApp::Application.routes.draw do
  resources :magazines do
    # provides a route to get all the articles for a given magazine.
    resources :articles, :only => :index
  end

  # provides all seven typical routes
  resources :articles
end
```

This generates a `/magazines/:magazine_id/articles` route. Requests
for this route will be sent to the `ArticlesController#index` action.

Let's see what the `ArticlesController` might look like:

```ruby
class ArticlesController
  def index
    if params.has_key?(:magazine_id)
      # index of nested resource
      @articles = Article.where(:magazine_id => params[:magazine_id])
    else
      # index of top-level resource
      @articles = Article.all
    end

    render :json => @articles
  end
end
```

The nested resource has a dynamic segment parameter `:magazine_id` that will
capture which magazine we are talking about.

## Restricting Member Routes

We can restrict what routes we build for a resource using the `:only`
option. Here, we tell the nested resource to only generate the
`:index` route.

If we didn't specifically restrict the routes, Rails would generate
all the typical routes for the nested resource:

* Collection routes
    * GET /magazines/:magazine_id/articles
    * GET /magazines/:magazine_id/articles/new
    * POST /magazines/:magazine_id/articles
* Member routes
    * GET /magazines/:magazine_id/articles/:id
    * PUT /magazines/:magazine_id/articles/:id
    * PATCH /magazines/:magazine_id/articles/:id
    * EDIT /magazines/:magazine_id/articles/:id
    * DELETE /magazines/:magazine_id/articles/:id

Here's a general design principle: there should be a exactly one URL
which maps to the representation of a resource; `/articles/101` and
`/magazines/42/articles/101` would both route to the same
`Article`. One of these is superfluous. Also, the `/magazines/42` bit
of the `/magazines/42/articles/101` path is
redundant. `ArticlesController#show` doesn't need the magazine id to
find the article; it can just use the article id directly. If we wish
to use the magazine_id, we can always look it up from the article id:

    Article.find(id).magazine_id

As a general rule, never generate any of the member routes when
nesting. Member routes should only belong to top level resources.
There's nothing wrong with defining the same resource at two
levels.

## Restricting Collection Routes

We now have three remaining collection routes we might nest:

* GET /magazines/:magazine_id/articles
* GET /magazines/:magazine_id/articles/new
* POST /magazines/:magazine_id/articles

The first one I like. This should trigger an index action to get all
the articles belonging to the given magazine. Note that this is
different from the top level `/articles` index route; that one should
return **all** the articles in the system. Because it returns a
subset, `/magazines/:magazine_id/articles` does **not** repeat the top
level index route in the way nested member routes do.

You **should not** have a nested create route. `create` is superfluous
like the member routes. It doesn't do anything differently from the
top-level route. So always create through the top level route.

We'll talk about `/magazines/123/articles/new` at a later date. This
route is not terrible, but not super useful, either.
