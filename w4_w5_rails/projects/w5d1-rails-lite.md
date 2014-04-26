# Rails Lite

In this project, we implement some of the basic functionality from
Rails. But before starting this project, make sure to finish up
ActiveRecordLite.

Here! Have a [skeleton of the project][rails-in-the-graveyard]. You
can just download the zip file or clone.

[rails-in-the-graveyard]: https://github.com/appacademy-solutions/rails_lite/

## Phase I: WEBrick

**WEBrick** is a web-server that comes packaged with Ruby. It receives
HTTP requests and sends responses back. Here are some core WEBrick
classes:

* http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
* http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
* http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
* http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

Write a file, `rails_lite/test/my_first_server.rb`. Create a new
`WEBrick::HTTPServer` on port 8080 (make sure you pass in the `:Port`
option with a capital "P", WEBrick is finicky about this). To write
your own custom handling of web requests, tell the server to use a
proc to serve responses. Use `HTTPServer#mount_proc`. You give it a
root URL and a proc which will be passed the `HTTPRequest` as well a
`HTTPResponse` to fill out. This proc will be called every time a 
request comes in to our webserver.

To start, set the root URL to `'/'`. Set the
`HTTPResponse#content_type` to `text/text` (also called the **mime
type**) and the `body` to the `HTTPRequest#path`. This should echo the
requested path back at you when you request a page from the server.

**Hint**: WEBrick doesn't like to shut down cleanly. Add this line
before you start the server:

    trap('INT') { server.shutdown }

## Phase II: Basic ControllerBase

The next step is to write a `ControllerBase` class. `ControllerBase` 
will provide us with some of the same functionality as 
`ActionController::Base` does in Rails -- for example, the `render` 
and `redirect_to` methods we're used to using in our controllers.

In the `test/00_server.rb` file, you'll see the `MyController` class 
inheriting from `ControllerBase`, much like Rails' controllers inherit 
from `ApplicationController` (which in turn inherits from `ActionController::Base`).
 Let's get started!

`ControllerBase#initialize` should take the `HTTPRequest` and
`HTTPResponse` objects as inputs; it will use the request (its query
string, cookies, body content) to help fill out the response. Save the
request and response objects to ivars for later use.

First, write a method named `render_content(body, content_type)`. This
should set the response's `content_type` and `body`. It should also
set an ivar, `@already_built_response`, so that it can check that
content is not rendered twice.

Next, write a method named `redirect_to(url)`. This needs to set the
response status and header appropriately. See [wikipedia][wiki-302]
for an example 302 redirect (note the HTTP status code and the
location header). Again, set `@already_built_response` to avoid double
render.

Run the test `ruby -I lib test/00_server.rb`. It will test
`render_content`. Also add your own `redirect_to` test to redirect to
google.com.

[wiki-302]: http://en.wikipedia.org/wiki/HTTP_302

## Phase III: Adding template rendering

### Phase IIIa: ERB and `binding`

ERB is built into Ruby. Here, have some [docs][erb-docs]!

[erb-docs]: http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html

Let's try it out:

```
[1] pry(main)> require 'erb'
=> true
[2] pry(main)> template = ERB.new('<%= (1..10).to_a.join(", ") %>')
=> #<ERB:0x007fcbcc0d5c60
 @enc=#<Encoding:UTF-8>,
 @filename=nil,
 @safe_level=nil,
 @src=
  "#coding:UTF-8\n_erbout = ''; _erbout.concat(( (1..10).to_a.join(\", \") ).to_s); _erbout.force_encoding(__ENCODING__)">
[3] pry(main)> template.result
=> "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
```

ERB will also interpolate values:

```
[5] pry(main)> x = "Hello there, world!"
=> "Hello there, world!"
[6] pry(main)> ERB.new("<%= x %>").result
[7] pry(main)> ERB.new("<%= x %>").result(binding)
```

`binding` is a special core Ruby method, that packages up the local
varaiables and makes them available in another context. For instance:

```
[8] pry(main)> def f
[8] pry(main)*   x = 4
[8] pry(main)*   binding
[8] pry(main)* end
=> nil
[9] pry(main)> fbind = f()
=> #<Binding:0x007fcbcc280538>
[10] pry(main)> fbind.eval("x")
=> 4
```

Calling `f` creates a local variable, which is usually not visible
outside the method. However, we return the variable `binding` to the
caller. The `Binding` class has one important method, `eval`, which
takes in text, running it as Ruby code.

You can see that `binding` is a very special method, and we'll hardly
ever use it. However, it should make sense what it does: capture all
the local variables in an object, so that the object can be passed to
and used in another context.

### Phase IIIb: reading and evaluating templates

Let's write a `render(template_name)` method that will:

0. use `File.read` to read in a template file (in the format
   `views/#{controller_name}/#{template_name}.html.erb`).
0. Create a new ERB template from the contents
0. Use `binding` to capture the controller's instance variables
0. Evaluate the ERB template
0. Pass the content to `render_content`.

Use `ActiveSupport`'s `#underscore` (`require
'active_support/inflector'`) method to convert the controller's class
name to snake case. You could chop off the `_controller` bit, or leave
that on if you're lazy like me.

Make sure this works by uncommenting the line in `test/00_server.rb`
and re-running.

[cookies]: http://en.wikipedia.org/wiki/HTTP_cookie

## Phase IV: Adding the Session

Overview:

WEBrick allows us to store [cookies][cookies]. To do so, we create a
`WEBrick::Cookie`, giving it a name and a value. We'll always use
a single default name, `'_rails_lite_app'`. Rails uses the project
name to keep sessions from different web-apps on the same server from
interfering with each other, but we don't have to worry about that.

For the cookie value, we'll take a Ruby Hash and serialize it to JSON.

Request cookies are available from `WEBrick::HTTPRequest#cookies`. You
can set a cookie in the response by creating a new `WEBrick::Cookie`
object and adding it to the `WEBrick::HTTPResponse#cookies` array.

Instructions:

Write a helper class, `Session` in `rails_lite/session.rb`, which is
passed the `WEBrick::HTTPRequest` on initialization. It should iterate
through the cookies, looking for the one named `'_rails_lite_app'`. If
this cookie has been set before, it should use JSON to deserialize the
value and store this in an ivar; else it should store `{}`.

Provide methods `#[]` and `#[]=` that will modify the session content;
in this way the Session is Hash-like.  Finally, write a method
`store_session(response)` that will make a new cookie named
`'_rails_lite_app'`, set the value to the JSON serialized content of
the hash, and add this cookie to `response.cookies`.

Write a method `ControllerBase#session` which parses the request and
constructs a session from it. Cache this in an ivar, (`@session`; use
`||=`) that can be returned on subsequent calls to `#session`.

Add calls to `Session#store_session` in `redirect_to` and
`render_content` so that the cookie is set.

Test this by uncommenting lines from `00_server.rb`.

Note: Browsers typically make separate requests for the favicon (the 
icon you see in the browser tab). If you refresh the page and notice 
the count increasing by 2 each time, don't worry - it means your
session hash is working.

## Phase V: params, params, params!

There are three kinds of params:

* Params that come from the router's match of the URL.
    * We'll do this later when we write the router.
* Params that come from the query string.
* Params that come from the request body.

### Phase Va: Query String params

The first params we will parse are the params that come in the query
string. We can access this through `HTTPRequest#query_string`.

The query comes in URL encoded form
(`http://www.bing.com/search?q=x`). URL encoded form is like JSON, we
need to parse it first. Check out the URI method
`URI.decode_www_form`. Have some [documentation][uri-decode-doc].

[uri-decode-doc]: http://www.ruby-doc.org/stdlib-1.9.3/libdoc/uri/rdoc/URI.html#method-c-decode_www_form

In the `Params` object, store an ivar (`@params`) which will be a hash
of params keys and values. Write a helper method
`parse_www_encoded_form` helper. In this method, parse a URI encoded
string, setting keys and values in the `@params` hash.

You will want to instantiate a `Params` object in your controller,
as an ivar.  This will keep track of the `params` for the controller.

Test out your work by running the `test/02_params_server.rb` test and
requesting the root URL with a basic query string like
`key1=val2&key2=val2`.

### Phase Vb: Learn Regex

Complete [RegexOne](http://regexone.com/).

### Phase Vc: Request body params

The next phase is to parse the parameters that are uploaded to the
server in the request body. Extend your `Params` object to parse not
only the query string, but also the request body. Look up how to read
the request body. Assume the request body is also in URL encoded format.

Go ahead and request the `/new` route, which should present a
form. Fill it out and submit it.

You should get output like this:

```json
{"cat[name]": "Breakfast", "cat[owner]": "Devon"}
```

What you want is this:

```json
{"cat": {"name": "Breakfast", "owner": "Devon"}}
```

The problem is that www form doesn't know how to "nest" hashes
(`status[title]`). We have to do this ourselves. Here's a regex you
can use to `split` a nested key into its components:

    /\]\[|\[|\]/

It's hard to read, but this tries to split on:

* `][`: the characters between one nested key and the next
* `[`: the character between the top-most key and the next
* `]`: the character after the bottom-most key.

`parse_key` should return an array of keys all the way down the
nesting. So `parse_key("cat[name]") == ["cat", "name"]`. Of course,
for standard keys, do `parse_key("top_level_key") ==
["top_level_key"]`.

Once you have this, modify your `parse_www_encoded_form` to call
`parse_key`. Iterate through the levels of keys. At each level (until
the last), create a deeper, empty hash. At the last level, set the
final key with the given value.

## Phase VI: Routing

In this section we'll be writing a `Router` class and a `Route` class. A 
`Route` object is like a single row of `rake routes`:

```
user    PUT     /users/:id      users#update
```

A `Route` object knows what URL to match (`/users/:id`), 
what controller it belongs to (`UsersController`) and what method to run 
within that controller (`update`).

Here is the `Router`'s job in a 
nutshell: given an `HTTPRequest`, figure out which `Route` matches the
requested URL. Once found, instantiate the `Route`'s controller, and run 
the appropriate method.

Let's get into more detail. Follow along by looking at the `server.mount_proc` 
section of `test/01_router_server.rb`.

When our app boots up for the first time it will instantiate a `Router`. The 
`Router` will have methods corresponding to the four HTTP verbs `GET, POST, PUT, DELETE`. 
Notice that in the `router.draw` block we call these methods with several 
arguments: a URL regex, a controller name, and a symbol that corresponds to a method 
name.

What each of the `get, post, put, delete` methods will do is add a `Route` 
object to the `Router`'s `@routes` instance variable.

On every WEBrick request `router.run` is called with the `HTTPResponse` and `HTTPRequest` 
as parameters. The run method will figure out what URL was requested, match it to the
URL regex of one `Route` object, and finally ask the `Route` to instantiate 
the appropriate controller, and call the appropriate method.

### Phase VIa: Write `Route` first

A `Router` keeps track of multiple `Route`s. Each `Route` should store
the following information:

* The URL pattern it is meant to match (`/users`, `/users/new`,
  `/users/(\d+)`, `/users/(\d+)/edit`, etc.).
* The HTTP method (GET, POST, PUT, DELETE).
* The controller class the route maps to.
* The action name that should be invoked.

Also write a method, `Route#matches?(req)`, which will test whether a
`Route` matches a request. NB: `req.request_method` returns a
capitalized string `"GET"` or `"POST"`; you'll probably want to
downcase and to_sym that before comparing.

### Phase VIb: Write the `Router`

* On `initialize`; setup an empty `@routes` ivar.
* Write a method `add_route(route)`, which will add to the router's
  list.
* Define `get(pattern, controller_class, action_name)`, `post(pattern,
  controller_class, action_name`, etc. methods.
    * Each one should construct a new `Route` and add it to the list.
    * To keep things DRY, iterate through an array of the HTTP
      methods, calling `define_method` for each.
* Pattern should be a regexp. Use `^` and `$` to match the
  beginning/end of the string.
* Write a method `Router#match` which finds the first matching route.

### Phase VIc: Invoking the action

* Add a method `ControllerBase#invoke_action(action_name)`
    * use `send` to call the appropriate action (like `index` or `show`)
    * check to see if a template was rendered; if not call
      `render` in `invoke_action`.
* Add a method `Route#run(req, res)` which
    * Instantiate an instance of the controller class (passing the
      request and response), and call `invoke_action`
* Add a method `Router#run(req, res)`
    * Run on the first matching route.
    * If none, return a 404 error (just set the response status).

### Phase VId: `Router#draw`

Write a method, `Router#draw` that takes a block:

```ruby
router = Router.new
router.draw do
  post Regexp.new("^/statuses$"), StatusesController, :create
  get Regexp.new("^/statuses/new$"), StatusesController, :new
end
```

Wait; `post` and `get` are methods of `Router`, but they aren't being
called directly on the `Router` here. What?

Ruby gives us a method called `Object#instance_eval(&proc)`. It lets
us pass a proc to `obj.instance_eval { method }`, and the proc will be
interpreted as if `self == obj`. So in this case, `obj.instance_eval {
method }` is the same as `obj.method`.

This is convenient for a large block of code where everything should
be run in the context of the router.

Run the `01_router_server.rb` test and try requesting `/statuses`,
`/users`.

### Phase VIe: Router params

Don't support the `/users/:id/` format. Our simple Router can expect
the format `/users/(?<id>)`, which is more complicated to write, but
[Ruby will do more of the work for you][named-capture-so] by using a
named capture.

In your `Route#run` method, you'll have to build a hash from the
`MatchData` returned from `regexp.match(str)`; the keys will be the
names of the captures, the values will hold their value.

Change the signature of `ControllerBase#initialize` so that it expects
to be passed a hash of params extracted from the URL by the
router. In `initialize`, pass the request and route parameters on to
`Params::new(req, route_params)`. The `Params` class should start with
the params from the router, then extend them with params from the
query string and request body.

[named-capture-so]: http://stackoverflow.com/questions/9642009/using-named-captures-with-regex-match-in-rubys-case-when
