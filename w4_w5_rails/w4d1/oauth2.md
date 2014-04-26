# Authentication and OAuth

## Goals

* Know what authentication and authorization are.
* Know what OAuth is.
* Know how to use the `oauth` gem.

## Authentication and Authorization

How do we make sure that only appropriate users are allowed to take
privileged actions? For instance, to post to your friend's wall on
Facebook, you need to log in first. Facebook will then be able to
check if you're friends and have permission to post to the other
user's wall.

There are two parts of the problem. The first is **authentication**:
we need to make sure that the user is who they say they are. We then
make sure that the user is **authorized** (i.e, has permission) to
make the request.

We'll learn how to do this with **OAuth**, which is a commonly used
system for authenticating a user so that a service (e.g., Twitter or
Facebook) can check credentials and make sure that requests are
authorized.

## Philosophy and Design of OAuth

Consider an application like Instagram which integrates with
Facebook. One way to give Instagram the power to post photos to your
wall would be to provide Instagram with your Facebook username and
password. Then Instagram could give Facebook your **credentials**
(username and password) whenever it tries to make an API request.

The average user may not be too keen on giving their password to any
site that integrates with Facebook. But there are other problems: how
do we limit Instagram to posting on the wall, and not messaging our
friends, too? How could we revoke Instagram's access to our Facebook
account short of changing our password?

These are the problems OAuth is designed to solve. Here's how it
works:

### Client keys

The engineers writing Instagram, the **client application**, must
register their app with Facebook (the **service**). They select what
permissions Instagram wants from Facebook users. In this case, perhaps
they wish to be able to post to the end user's wall. Instagram does
not necessarily need a list of all the user's friends, nor the ability
to send Facebook messages to those friends. So when the Instagram
engineers register with Facebook, they don't select those permissions.

Facebook issues Instagram a set of **keys** (sometimes called the
**client key**/**client secret**). Instagram will use these keys to
prove that a request is coming from Instagram.

### End User Approval

When a user signs up with Instagram, Instagram will need permission to
post to the user's wall. The Instagram app will redirect the user to a
special URL hosted by the service (Facebook). This page will inform
the user what permissions the client application (Instagram) is asking
for. The user can decide whether they wish to give Instagram these
permissions.

The user will have to be logged into the service (Facebook); if they
are not already logged in, they will first hit a login screen.

The user will have the option to approve the permissions request. If
they do, the service (Facebook), will redirect the user back to the
client application (Instagram).

### User Access Token

When the user is redirected back to the client application
(Instagram), they will be directed to a special page on the client. The
URL they are redirected back to will embed a password for the client
(Instagram) to use when accessing the service (Facebook) on behalf of
the user. This password is often called the **access token**. The
client application (Instagram) will extract the access token from the
URL and store it in their database.

### API Requests

Now that the user has authorized the client (Instagram), it can use
the access token to make any needed API requests to the service
(Facebook). The client (Instagram) will also use its client key so
that the service (Facebook) can make sure that it is in fact the
application making the request on behalf of the user.

The service (Facebook) will not allow the client (Instagram) to make
any requests that the user has not previously authorized.

### Summary

Because the user only inputs their password on a service webpage, the
client application never receives the user password. This is majorly
important, because we don't want to trust every site with our FB
passwords.

The user has the opportunity to examine what permissions the client is
asking for. This system encourages client application writers to ask
for no more permissions than necessary. The user also knows what they
are getting into.

The key issued to the client may be revoked by the user (or service)
at any time. This can be done without affecting any other clients the
user may have authorized. This means we can easily shut off abusive
applications.

## Our First OAuth application

We'll let the [oauth][oauth-ruby-github] gem take care of many details
of OAuth for us. Let's write a small client application to fetch a
user's timeline from Twitter.

[oauth-ruby-github]: https://github.com/oauth/oauth-ruby

### Setup

First, we'll need to register our app with Twitter. Head to
https://dev.twitter.com/apps/new (you will need to be logged
in). Choose a name and description. For website, put a placeholder
like `appacademy.io`; this is only used to show the user a link
describing your application.

Normally we would specify a **callback URL**, which is where the user
will be redirected after authorization; the application web server
would receive this request, which embeds the access token. The server
would normally extract the key and store it for future use on behalf
of the user.

We're not going to create a web app today, so there is no webserver to
receive the key this way. Instead, by leaving this field blank the
user will be given a numeric code which they can in turn type into the
application. The application will use this one-time pin to request a
key directly from Twitter. This is inconvenient for the user, but will
serve our purposes fine for today.

### Code

```ruby
require 'launchy'
require 'oauth'

# "Consumer" in Twitter terminology means "client" in our discussion.
# God only knows who thought it was a good idea to make up many terms
# for the same thing.
CONSUMER_KEY = "consumer_key_from_service"
CONSUMER_SECRET = "consumer_secret_from_service"

# An `OAuth::Consumer` object can make requests to the service on
# behalf of the client application.
CONSUMER = OAuth::Consumer.new(
  CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

# Ask service for a URL to send the user to so that they may authorize
# us.
request_token = CONSUMER.get_request_token
authorize_url = request_token.authorize_url

# Launchy is a gem that opens a browser tab for us
puts "Go to this URL: #{authorize_url}"
Launchy.open(authorize_url)

# Because we don't use a redirect URL; user will receive a short PIN
# (called a **verifier**) that they can input into the client
# application. The client asks the service to give them a permanent
# access token to use.
puts "Login, and type your verification code in"
oauth_verifier = gets.chomp
access_token = request_token.get_access_token(
  :oauth_verifier => oauth_verifier
)

# The `OAuth::AccessToken` object lets us make HTTP requests on behalf
# of the user. It has the same methods as restclient. Unlike
# restclient, requests made using this token will also include the
# client keys and the user's access token, so that the service can
# make sure the request is properly authorized.
response = access_token
  .get("https://api.twitter.com/1.1/statuses/user_timeline.json")
  .body

puts response
```

Read and then go ahead and copy this code into a Ruby file and run it
to try the code out! Make sure to set your consumer key pair with the
values you got when you registered the app with Twitter.

## Storing An Access Token

Everytime you run our script, you'll be asked to re-authorize the
app. This is unnecessary after the first time. Let's modify the
application to store the access token for later re-use.

```ruby
require 'yaml'

TOKEN_FILE = "access_token.yml"

def get_token
  # We can serialize token to a file, so that future requests don't
  # need to be reauthorized.

  if File.exist?(TOKEN_FILE)
    # reload token from file
    File.open(TOKEN_FILE) { |f| YAML.load(f) }
  else
    # copy the old code that requested the access token into a
    # `request_access_token` method.
    access_token = request_access_token
    File.open(TOKEN_FILE, "w") { |f| YAML.dump(access_token, f) }

    access_token
  end
end
```

Make the necessary modifications to the original script. You should
not have to get a PIN after the first authorization, now.

## Storing Client Keys

Your client key and secret should be kept, duh, secret. If hackers got
access to the client keys, they will be able to pose as your client
application and make requests on behalf of your users. For our
purposes, this is no big deal, but you can imagine that Instagram
would guard its Facebook API secrets closely (so that rivals or
troublemakers can't deface their user's accounts).

In particular, if your github repository is public, you must not check
your API secrets into source control. Even if it is private, you may
not want everyone in your company (and all your untrustworthy
contractors) to have access to your client keys.

When using Rails, one solution is to use the [figaro][figaro]
gem. We'll return to it later in the course, but you can take a look
at it if you like.

[figaro]: https://github.com/laserlemon/figaro

## Omniauth

When we write web apps, we won't want to use this half-assed PIN
flow. We'll eventually learn to use [omniauth][omniauth], which will
handle redirecting users to the service and also their return via the
URL callback. Another day! Soon!

[omniauth]: https://github.com/intridea/omniauth
