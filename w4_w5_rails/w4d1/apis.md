# APIs

## Goals

* Know what an API is.
* Know how to use RestClient to make the four standard HTTP requests.
  * Know how to send a payload.
* Know how to use `addressable/uri` to build URLs.

## What is an API?

When humans use a browser to visit a website, the browser submits an
HTTP request, and the server replies with HTML which holds the content
and layout of the page to be displayed. The web browser then
**renders** the HTML: it turns the HTML code into the graphics that
are displayed on your screen. Users then interact with the page by
clicking links or hitting buttons, making new HTTP requests which
start the cycle again.

A [Web API][wiki-api] (Application Programming Interface) is a
different way of interacting with a web application that makes it easy
for another computer program (a **client**) to interact with the
application. For instance, maybe you're writing a command line program
to check your tweets on Twitter. A program like this doesn't need all
the extra layout information that is contained in HTML; you just want
the raw tweet data, which your program will decide how to present to
the user in the terminal.

When the page layout information encoded in HTML is unnecessary and
only the data matters, the client and server typically communicate by
passing around a format like [JSON][wiki-JSON] or
[XML][wiki-XML]. Unlike HTML, these **data-oriented** formats will not
contain information about how to visually format the content.

Because no HTML is returned, there are no links to click. How do you
know what requests to make to the server? For instance, how would we
know how to GET a tweet from Twitter?

The answer is that API providers publish documentation describing how
to use the API. For example, see Twitter's [docs][twitter-doc]. These
documents describe the HTTP requests you can make to the server, how
to use them, and what they do.

By using APIs your program can interact with the outside world. It
could read tweets from Twitter, it could make posts to Reddit, etc.

[wiki-api]: http://en.wikipedia.org/wiki/API#Web_APIs
[twitter-doc]: https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
[wiki-JSON]: http://en.wikipedia.org/wiki/JSON
[wiki-XML]: http://en.wikipedia.org/wiki/Xml

## Formatting URLs with `Addressable`

It can be a pain to hard-code long URL strings into your code. This is
particularly annoying if you need to update a part of the URL, and
especially if you have query strings. In general, don't store encoded
data like that: get Ruby to do the work for you. If you're building
URLs with string interpolation, **you're doing it wrong**.

Install the `addressable` gem, then you can use:

```ruby
> require 'addressable/uri'
> Addressable::URI.new(
  :scheme => "http",
  :host => "www.bing.com",
  :path => "search",
  :query_values => {:q => "test"}
).to_s
=> "http://www.bing.com/search?q=test"
```

The advantage to this is especially felt when updating query values;
you won't have to futz with converting to URL encoding yourself. The
rules for URL encoding are somewhat tricky, and simple string
interpolation will not work.

## `RestClient`

We've talked a lot about HTTP requests. But we haven't seen how to
write programs that issue requests yet. In Ruby, we'll use the
[RestClient][rest-client] gem to do this.

[rest-client]: https://github.com/rest-client/rest-client

Here's how to issue a GET request with RestClient:

```ruby
> require 'rest-client'
> puts RestClient.get("http://graph.facebook.com/kush.patel2")
#=> {"id":"2906705","name":"Kush Patel","first_name":"Kush","last_name":"Patel","username":"kush.patel2","gender":"male","locale":"en_US"}
```

RestClient has made the GET request, and it returns the contents as a
string. Because the response is in JSON format, we can parse the JSON
object and create a Ruby Hash out of it:

```ruby
> require 'json'
> response = RestClient.get("http://graph.facebook.com/kush.patel2")
> kush = JSON.parse(response)
> kush.class
#=> Hash
> kush["name"]
#=> "Kush Patel"
```

Now the response from Facebook has been fully interpreted and
translated into a Ruby object.

We can also make a POST request like so:

```ruby
> endpoint = "http://99cats.com/cats"
> params = { :cat => { :name => "Haskell", :skill => "jumping" } }
> RestClient.post(endpoint, params)
```

This POSTs the submission parameters to the **endpoint**; endpoint is
another name for an API **resource**. Here we're POSTing a cat
submission to a fictional 99cats web application. Restclient will take
our hash of params and URL encode it. The contents will be submitted
in the request body.

Likewise there are `RestClient.put` and `RestClient.delete`
methods. They operate similarly.

## References

* Begin to explore what [RESTful][restful-so] means!

[restful-so]: http://stackoverflow.com/questions/671118/what-exactly-is-restful-programming

