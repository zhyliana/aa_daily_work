# HTTP

## What is HTTP?

HTTP is the **HyperText Transfer Protocol**. Whenever you visit a
webpage, your browser first issues an HTTP **request** for the page to
the server, which then issues a **response** back to your computer
containing the HTML and content. HTTP is a request-response protocol.

A **protocol** specifies the format and rules for exchanging
messages. In this case, it's about specifying the rules between
clients (usually a web browser) and server (a web server hosting the
page).

Let's see an HTTP request get made, and its response. This request is
made from the command line (as opposed to a browser):

![http request cycle](http://upload.wikimedia.org/wikipedia/commons/c/c6/Http_request_telnet_ubuntu.png)

That's a lot, but for now, let's just focus on the structure.
The part in red is the request, and more specifically, the
request headers.

The user specifies a **method** (`GET`), a **resource** (or, in
layman's terms, the "page": `/wiki/Main_Page`), the protocol version
(`http/1.1`) and the **host** (`en.wikipedia.org`). The steps of the
protocol are:

0. The client (usually a web browser) issues a request.
0. The request will be routed through the internet to the host (a
   server for `en.wikipedia.org`).
0. The server will then generate the response. A `GET` request asks
   the server to retrieve a resource for the client; the server will
   probably query the database for some data and build an HTML page
   presenting the data.
0. The server sends the reply back to the client.

The response from the server is in blue and in green. The green part
is the **body**, or meat of the response. This is the content that was
requested. Here, it's an HTML web page.

The blue part consists of the **headers**; the headers are not part of
the content proper, but they contain valuable information for the
requester. The most important one is the **status code** which tells
the client whether the request was successful. The status code is in
the first line of the headers: `HTTP/1.1 200 OK`. 200 is the "OK"
status code; everything worked fine. Other common status codes are for
a missing resource (404 Not Found), a redirection to another resource
(301 Moved Permanently), and an unauthorized request (403 Forbidden).

There are generally many other headers returned, and though they are
sometimes important, usually they are inconsequential for our
purposes.

Let's move on to discuss the protocol methods in a little more detail.

## HTTP methods (verbs)

Each HTTP request that is made asks the server to do something. By far
the most common request is a **GET**, which asks the server to fetch a
resource and return it. **POST** is another common type of request; a
POST request asks the server to accept some uploaded data, and store
it. When you submit an HTML form, you typically POST the contents of
the form to the server.

There is also a **PUT** request, which differs slightly from POST;
POST is used to create new resources (e.g., create a new customer in
the database), while PUT is used to update an existing resource (e.g.,
update a customer's address). Like POST, PUT uploads data to the
server. PUT technically is supposed to "replace" the existing resource.

In Rails 4 the **PATCH** method was introduced to be used as default
instead of PUT. The PATCH method is used to update only parts of
existing entities.

Finally, there is the **DELETE** method; this is used to delete an
existing resource; for instance, perhaps we lose a client, and want to
delete the customer from our database.

| Verbs | Use case |
| ----- | -------- |
| GET | Retrieves a resource (no side effects, safe) |
| POST | Creates a new resource |
| PUT | Replaces a resource |
| PATCH | Modifies a resource |
| DELETE | Deletes a resource |

### Method safety

As we've mentioned, some of these HTTP methods are used to ask a
server to create, modify, or delete data stored in the server's
database. By convention, a `GET` request **should not** result in the
server modifying any data. Writers of web applications **should**
ensure that a `GET` request won't do this, intentionally or otherwise.

A `GET` request is supposed to be **safe**; no harm should be done
just by asking for a representation of a resource. Web crawlers like
googlebot rely on this, because googlebot will follow links (clicking
a link typically issues a `GET` requests) but will not make `POST`,
`PUT`, or `DELETE` requests.

In older days, inexperienced devs would not always respect this
convention. For instance, they might create a link to
`posts/1234?delete`. They would then write server code that would
delete the resource if `delete` was included in the query string, even
though this was an HTTP `GET` request.

So googlebot would come along, crawl all the links on the
page, and delete all the posts. At the time, Google got a lot of
complaints about this kind of thing.

The solution was for devs to respect the HTTP conventions. Instead of
linking a `GET` request for `posts/1234?delete`, the page should have
a button which, when clicked, issues a `DELETE` request for
`posts/1234`. Notice also that the method action is expressed by the
HTTP verb and not duplicated within the URL. That's kind of nice, too.

Of course, why did they let an unauthenticated user delete posts
anyway? :-)

## HTTP and application servers

HTTP requests are processed by web application servers, which are
computer programs that are responsible for generating the
response. The application can respond to the request by doing anything
it wants. It is up to the application to decide that when I make a
`GET` request for `/posts/1234` this means to **render** (or produce)
an HTML page representing post #1234 to send back.

That would be a reasonable response. But the server could choose to do
something unreasonable if we wanted to program it that way. It could
respond to this request by deleting a post from the database,
returning a random entry, or just about anything.

The point here is that HTTP is a way to communicate requests and
responses. The methods of HTTP provide a **user** with the means to
**describe** what they would like the server to do. But it is
ultimately the application code on the **server** which determines
**how to** satisfy a request. To say it again: HTTP doesn't define how
the request gets processed; that will be our job as web developers.

## What's a URL?

[URL][url] is an abbreviation for uniform resource locator, and is
commonly known as your everyday web address. By now you've probably
seen billions of them, but let's examine the technical parts that make
up a URL.

    scheme://host:port/path?query_string#fragment_id

* The **scheme** tells us what protocol we would like to use. The two
  schemes we are interested in are `http` and `https`
  ([HTTPS][http-secure] is the secure encrypted version of the http
  protocol). This is always required.
* The **host** can be either a domain name `www.appacademy.io` or an
  IP address `107.21.218.20`. This is always required.
    * If a host name is given, a [DNS][wiki-dns] lookup will be
      required to translate the human-readable name to a
      computer-friendly IP address.
* The **port** lets you specify the port of the web server you want to
  send this request to. This is optional. By default `http` will use
  port 80 and `https` will use port 443.
    * The development Rails server you use on your local machine will
      likely use port 3000; the full url will be
      `http://localhost:3000/`.
    * `localhost` is a special host that means the current, "local",
      machine: your own computer.
* The **path** is used to identify different resources on the
  server. Often it will mimic a directory structure: e.g.,
  `/users/1/posts/1234`. The path is optional; if left out, the path
  defaults to the **root path**, which is `/`.
* The **query string** allows us to send additional information along
  with our request, in [URL encoded][url-encoding] key-value
  pairs. The start of the query string is signalled by the question
  mark.
    * Key and value are separated by `=`.
    * Key-value pairs are separated by `&` ampersands.
    * Here is an example query-string: `?animal=cat&color=brown`.
    * There are other annoying rules to escape `?`, `=`, `&`,
      etc. Never try to build query strings on your own. Use a library
      to help you.
* The **fragment id** is the part after the `#` hash mark. It is often
  used to indicate a place to jump to on a web page. For instance,
  click [#whats-a-url](#whats-a-url).
    * For now, don't worry much about fragments. They'll come up again
      in the context of JavaScript later.

[url]: http://en.wikipedia.org/wiki/Uniform_resource_locator
[wiki-dns]: http://en.wikipedia.org/wiki/DNS
[http-secure]: http://en.wikipedia.org/wiki/HTTP_Secure
[url-encoding]: http://en.wikipedia.org/wiki/Percent-encoding

## Request body and query string

When we make a POST or PUT request, we can upload content to the
server by embedding it in the request's body. An example that might
create a new `Judge` entry for [Joe Brown][joe-brown], the famous and
esteemed jurist:

[joe-brown]: http://en.wikipedia.org/wiki/Joe_Brown_(judge)

```
POST /judges HTTP/1.1
Host: law.com
Content-type:application/x-http-form-urlencoded

name=Joe+Brown&court=television+court
```

Here the request content is `name=Joe+Brown&court=television+court`,
which is URL encoded like the query string.

We specify the content-type in a request header so that the server
knows how to decode the **payload** (here the full format name is
`x-http-form-urlencoded`).

URL encoding is often used for request bodies; it is the format
generated by web-browsers when you submit an HTML form. However, you
can send any content-type in a POST request body; it is common to use
JSON, for instance:

```
POST /judges HTTP/1.1
Host: law.com
Content-type:application/json

{ "name": "Joe Brown" "court": "television court" }
```

GET requests don't have a body. How can a GET request send data to the
server? For instance, to perform a search, we might make a GET request
to www.bing.com for the `/search` resource. This asks the server to
perform a search, but for what?

We embed our query in the **query string**. The query string is an
optional part of the resource, separated from the rest by a question
mark. For example, in the url

    www.bing.com/search?q=where+in+the+world+is+carmen+sandiego

Go ahead. Paste it in. I'll wait.

The resource is `/search`, the query string is
`q=where+in+the+world+is+carmen+sandiego`. When the Bing server
receives the GET request it will also have access to the query string
embedded in the path. You can think of the query string as a URL
encoded version of the hash

```ruby
{ :q => "where in the world is carmen sandiego" }
````

The Bing server will use the query string parameters to build its
response to the GET request: presumably, it will treat the value keyed
by "q" as the **query**. It will somehow look up the query in the Bing
databases to produce a page of search results. An HTML page is then
built to present the search results, which is the content that will be
returned to the requesting browser.

## Exercises

Estimated time: .25hrs

### Netcat

`nc` ("netcat") is the simplest, lowest-level program for
communicating with a server. You give `nc` a hostname and port (`nc
www.google.com 80`) and it opens a connection to that server.

After starting netcat, you can then start writing an HTTP request in
the console. Follow the format in the image above to make a request to
Wikipedia, as well as another to Google.

The server will know your request is complete when it sees a blank
line. Observe the blank line at the end of the request portion in the
example above; when you add one, the server will know that your
request is over and should begin issuing its response.

Make sure to get the path part of the first request line right: look
carefully at the example (`/wiki/Main_Page`). You always must specify
a path when making a request; the most basic path is `/`.

When you query Google, you should know that it may be picky about
requests: it expects `HTTP/1.1` rather than `http/1.1` last I checked.

You may also have a problem where the server closes the connection
before you get the chance to completely enter your request. Write your
request in TextMate and then paste the contents into the console.

Note that you have to repeat the host both on the command line where
you invoke `nc` and within the request body. This is because `nc` uses
the command line argument to look up the IP address of the machine to
talk to. It can then establish a connection with this machine, but the
machine may host many web services: for instance, the same machines
may host both German and English Wikipedia. A request sent to the
Wikipedia server needs to say whether this was for German or English
Wikipedia, otherwise the server won't know. That's why we need to also
include the `Host` within the request.
