# Building a JSON API

A typical Rails app will have its controllers build HTML that will
then be displayed (**rendered**) by the browser that made the
request. As we saw yesterday, browsers aren't the only program that
can make HTTP requests. When a non-browser client makes an API
request, the requestor would much prefer a raw representation of the
data rather than a mess of HTML that includes all sorts of extraneous
formatting information and is difficult to parse.

We've previously learned how to consume a JSON API. In this chapter,
we'll learn how to build one.

Consumers of a web API can be third-party developers, but you can also
consume your own API. Your web app may contain JavaScript code that
the user's browser runs; this JS code may make background requests to
the API to dynamically update content. We'll wait until we learn
JavaScript to talk about this, but the point is that even if you don't
support third-party partners, you may find yourself using your own
API.

APIs are big, friend.

## JSON & Rails

The key to building a Rails API is to get your controllers to convert
model objects into JSON, and then return the JSON. This requires
support at two layers: the model layer (convert a model to JSON) and
the controller layer (return the JSON to the user).

### Models & `to_json`

Let's take a look at the model layer:

```
$ rails console
> Wizard.first
=> #<Wizard id: 1, fname: "Harry", lname: "Potter", house_id: 1,
school_id: 1, created_at: "2013-06-04 00:31:04",
updated_at: "2013-06-04 00:31:04">

> Wizard.first.to_json
=> "{\"created_at\":\"2013-06-04T00:31:04Z\",\"fname\":\"Harry\",
\"house_id\":1,\"id\":1,\"lname\":\"Potter\",
\"school_id\":1,\"updated_at\":\"2013-06-04T00:31:04Z\"}"
```

Note that the `to_json` method actually produces a JSON string.

### Controllers & `render :json =>`

Controllers, too, support responding to a request with JSON.

Remember that all controller actions must end in some response back to
the requestor. That response in Rails is built by calling either
`render` (places something in the response body) or `redirect_to`
(sends a response that asks the requestor to make a whole new request
to a different URL).

Usually, when we call `render`, we'll specify an **HTML
template**. An HTML template consists of HTML code, with annotations
where data can be inserted. We'll learn more about them soon.

Today we just want to send a JSON representation of a certain
object. Easy enough:

```ruby
class UsersController < ApplicationController
  def index
    users = User.all
    render :json => users
  end

  def show
    user = User.find(params[:id])
    render :json => user
  end
end
```

A few things to note:

* The controller specifies that it is rendering JSON with `render
  :json =>`.
* Under the hood, the object you pass will automatically have
  `to_json` called on it, so there is no need to explicitly call it on
  the object.
* `to_json` works on both collections (arrays) and individual objects.

And now you know everything about JSON!

## Resources

* [`to_json` or `as_json`?][to-json-as-json]

[to-json-as-json]: http://jonathanjulian.com/2010/04/rails-to_json-or-as_json
