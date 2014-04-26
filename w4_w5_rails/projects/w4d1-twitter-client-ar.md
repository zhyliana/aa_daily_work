# Twitter Client

The purpose of this project is to build a Twitter client. Imagine it
like a desktop email client program. At some interval, or at the user's
behest, the program fetches messages from the server and stores them
so that the program will behave responsively. Our program will behave
similarly. It will download 'tweets' from the twitter database and 
store them in its own database so that when our program is used,
it doesn't need to query the Twitter API to show the user old tweets.
 
We'll use the [Twitter API][api-docs] and [Active Record][ar-basics]
to build the back-end of a Twitter [CLI][wiki-cli]. We want to fetch
and post Tweets through the Twitter API. We also want to be able to
save Tweet data to a database for offline use.

We will use the [OAuth gem][oauth-github]. Make sure to check out the
example at the end of the [OAuth chapter][oauth-chapter]. Using OAuth
will allow our application to act on behalf of our users.

[wiki-cli]:http://en.wikipedia.org/wiki/Command-line_interface
[ar-basics]:http://guides.rubyonrails.org/active_record_basics.html
[api-docs]: https://dev.twitter.com/docs/api/1.1
[oauth-github]: https://github.com/oauth-xx/oauth-ruby
[oauth-chapter]: ../w4d1/oauth2.md

## Phase I: `TwitterSession`

Set up a new Rails project with `rails new [project name]`.

NOTE: Before starting, set up API access for a new Twitter app and set
it up to request read/write/dm access.

We want to interact with Twitter on behalf of our user. This
will involve getting an access token as we saw in the reading's
demonstration.

To handle interaction with Twitter, let's write a `TwitterSession`
class. The `TwitterSession` class will obtain the access token, and we
will use it to make API requests to Twitter. This will allow the rest of
your application to ignore the details of OAuth and instead rely on
`TwitterSession` to take care of the details.

No code outside `TwitterSession` should do anything related to OAuth,
and every API request should go through `TwitterSession`. This is a
standard object-oriented way to do things.

Begin by writing a `TwitterSession` class in the `lib/`
directory. This is the interface I would expect `TwitterSession` to
supply.

```ruby
class TwitterSession
  # Both `::get` and `::post` should return the parsed JSON body.
  def self.get(path, query_values)
    # ...
  end

  def self.post(path, req_params)
  end
end

TwitterSession.get(
  "statuses/user_timeline",
  { :user_id => "737657064" }
)
TwitterSession.post(
  "statuses/update",
  { :status => "New Status!" }
)
```

Notice that the user of the `TwitterSession` doesn't want to bother
instantiating the `TwitterSession` class, nor explicitly getting the
access token. The access token should be loaded from a file or fetched
from Twitter only when first needed. Let's see how we might do this:

```ruby
class TwitterSession
  # Call `::access_token` from `::get`/`::post` methods...

  def self.access_token
    # Load from file or request from Twitter as necessary. Store token
    # in class instance variable so it is not repeatedly re-read from disk
    # unnecessarily.
  end

  def self.request_access_token
    # Put user through authorization flow; save access token to file
  end

  def self.path_to_url(path, query_values = nil)
    # All Twitter API calls are of the format
    # "https://api.twitter.com/1.1/#{path}.json". Use
    # `Addressable::URI` to build the full URL from just the
    # meaningful part of the path (`statuses/user_timeline`)
  end
end
```

**Hint**: To get Rails to autoload changes to files in the `lib/`
directory, add this line to `config/application.rb`:

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

**Hint**: `TwitterSession` is not a model and should not be stored in
a table nor inherit from `ActiveRecord::Base`.

**Hint**: Write `CONSUMER_KEY` and `CONSUMER_SECRET` constants in
`TwitterSession` to store your client app's credentials.
You can load these from `.gitignore`d files using something like:
```ruby
CONSUMER_KEY = File.read(Rails.root.join('.api_key')).chomp
```
For more on protecting your keys, see [this hint][guard-keys]
from the Ice Cream Finder project.

When you've done this, you should be able to do like so:

```ruby
[1] pry(main)> require './lib/twitter_session.rb'
=> true
[3] pry(main)> puts TwitterSession.get("statuses/user_timeline", { :user_id => "737657064" })
# SAGE TWEETS GO HERE
[4] pry(main)> TwitterSession.post("statuses/update", { :status => "I'm a robot! Fear me!" })
```

## Phase II: Building the Model Layer

We want to write an application that will allow the user to
access/post tweets through the API.

Additionally, we want to build the application so that, even if the
internet is down, we can still display previously fetched data from
the server. It won't be up-to-date, but it's the best we can do.

For this reason, we want to store data fetched from Twitter in our own
SQL database.

### Phase IIa: `Status` Model and `Status::fetch_by_user_id!`

Twitter calls a tweet a `Status`. Let's make an ActiveRecord model for
a `Status`. Let's describe the `statuses` table. We want to store
three things about a fetched `Status`:

* `status["text"]` (a `String`, and less than 140 chars)
    * I called this `body` in my table.
* `status["id_str"]` (a `String`, not an integer)
    * I called this `twitter_status_id` in my table
    * This is Twitter's id for this tweet. Our own `id` from the
      database is not enough; we need to record the id that Twitter
      uses for the `Status`.
    * Add a uniqueness DB constraint and Rails validation to
      ensure that the same tweet is not stored twice.
* `status["user"]["id_str"]` (a `String`, not an integer)
    * I called this `twitter_user_id` in my table; it's Twitter's id
      for the author.

All these attributes are required and should have DB not null
constraints and Rails presence validations.

Next, write a `fetch_by_twitter_user_id!(twitter_user_id)`
method. Using the Twitter API documents and your `TwitterSession`
class, fetch the user's timeline and make a web request to Twitter.

Your method should start out by just returning the raw JSON
data. Verify that it works. Next, write a `Status::parse_json`
method. It should take the Twitter params and build a `new` status. It
should just pull out the three relevant fields. For now, **don't save
them** to the database.

```ruby
statuses = Status.fetch_by_user_id!("737657064")
# array of statuses written by user 737657064, `ned_ruggeri`
```

### Phase IIb: Persisting `Status` Objects

You are fetching `Status` objects, but we haven't saved them to the DB
for later use yet. To do this, iterate through the fetched, parsed
`Status` objects and call `#save` on each one. Note that a tweet you
have previously fetched will not be re-saved and duplicated if you
added the proper uniqueness validation.

This is wasteful because it will try to save many statuses that have
already been pulled down to the client in the past. In particular,
each time Rails checks a uniqueness validation, it must make a
database query to see if a record already exists with the given
attribute. That means if that even if there are no new statuses
fetched, we have to run a validation query for each of `N` old
statuses.

To fix this, before saving any `Status` objects, let's first use
`ActiveRecord::Base::pluck` and `::where` to pull the
`twitter_status_id`s of all previously saved statuses for this
user. Use these `old_ids` and `Array#select` to filter the fetched
status to only those that have not been saved before.

You can now also explicitly skip trying to save previously-fetched
statuses (which will save many DB queries). And you can use `save!`,
instead, since you now expect all the new statuses to insert
successfully. :-)

### Phase IIc: Posting New `Status`es

Write a `Status::post(body)` method that posts a tweet as the current
user. Again, use `TwitterSession`. Capture the response from the
`POST` request to parse and `save!` a new `Status` entry on the spot.

### Phase IId: Using `Status` While Offline

Let's write a `Status::get_by_twitter_user_id` method. Let's have it:

* Check whether the internet is up.
* If so, it should call `fetch_by_twitter_user_id!` to fetch
  `Status`es.
* Either way, it should use `where` to fetch tweets from the DB. Even
  if the internet is down we can still pull previously fetched tweets.

To test whether the internet is availble, you can use this
cut-and-paste code:

```ruby
# from http://stackoverflow.com/questions/2385186/check-if-internet-connection-exists-with-ruby
require 'open-uri'

def internet_connection?
  begin
    true if open("http://www.google.com/")
  rescue
    false
  end
end
```

Verify this works by flipping your wireless off and giving it a go!

## Phase IIIa: Twitter `User`s

One annoying thing is that we must lookup `Status`es using the numeric
identifier of a user, and not their name. Let's create a `User` model
to shadow the Twitter API's object.

We need two important attributes for `User`:

* Screen name
* Twitter user id

Validate the presence and uniqueness of each of these (DB constraint +
Rails validation), and add indices for fast lookup.

Write `User::fetch_by_screen_name!` and `User::get_by_screen_name`
methods. If the screen name is not already stored in the DB, use the
`users/show` Twitter API endpoint to fetch the user id. Store this in
the DB. Else, just return from the DB. As before, write a
`::parse_twitter_user` helper method.

### Phase IIIb: Associations

Write an association for a `Status` that returns the `User` who
authored it. You should use the `twitter_user_id` for the association;
don't use the local DB's `id`.

Write an association that returns the `Status`es a `User` has
authored.

Lastly, write a method `User#fetch_statuses!` that calls
`Status::fetch_by_twitter_user_id!`. I want to be able to write:

```ruby
irb(main):002:0> user = User.fetch_by_screen_name!("appacademyio")
   (0.1ms)  BEGIN
  SQL (2.0ms)  INSERT INTO "users" ("created_at", "screen_name", "twitter_user_id", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["created_at", Mon, 16 Dec 2013 08:25:49 UTC +00:00], ["screen_name", "appacademyio"], ["twitter_user_id", "588716514"], ["updated_at", Mon, 16 Dec 2013 08:25:49 UTC +00:00]]
   (4.2ms)  COMMIT
=> #<User id: 3, twitter_user_id: "588716514", screen_name: "appacademyio", created_at: "2013-12-16 08:25:49", updated_at: "2013-12-16 08:25:49">

irb(main):003:0> statuses = user.fetch_statuses!
=> Inserts many newly fetch statuses
irb(main):004:0> statuses = user.fetch_statuses!
=> Doesn't insert anything; no new statuses to fetch.
```

## Bonus Phase IV: `Follow`

**TODO**: this part needs rewriting.

### The `Follow` model

Author a new model named `Follow`. It should contain two ids:

* `twitter_follower_id`
* `twitter_followee_id`

These should be `NOT NULL`. Add indices for both columns for fast
lookup. Add an index on the pair of columns to enforce uniqueness. Add
Rails-level validations for these, too.

Add `Follow#follower`/`Follow#followee` associations. Add
`User#inbound_follows`/`User#outbound_follows` associations. Add
`User#followed_users`/`User#followers` associations.

### Write `User::fetch_by_ids`

Write a `User::fetch_by_ids(ids)` that takes an array of
`twitter_user_id`s. It should only make an API request for `User`s you
have not previously fetched from Twitter. Accomplish this by querying
`users` to find existing `User`s with the given ids.

For the ids you don't find, make an API call to Twitter. Twitter has a
way to do a bulk lookup of `User` objects. Find and use this method.

Return both the records you found that were already in the DB, plus
the records newly fetched from Twitter.

### Write `User#fetch_followers`, `User#sync_followers`

Write a `#fetch_followers` method that makes an API request to get the
ids of a `User`'s followers on Twitter (check out the `stringify_ids`
option). Then use your `User::fetch_by_ids` method.

Write a `User#sync_followers` method that calls `fetch_followers` and
then iterates through the unpersisted `User` objects, `save!`ing them
to the DB.

Lastly, `sync_followers` needs to create new follows in the join
table. Try doing this two ways:

0. Iterate through the existing follows. For each follow, check if the
   `followee_user_id` is amongst the follower ids you've fetched from
   Twitter; if not, destroy the `Follow` object. Next, iterate through
   the followers you've fetched from twitter. If they are not, create
   a new follow object.
0. Use the `followers=` method that Rails will generate for you when
   you define the `followers` association. Just call the setter method
   and pass in the result of `fetch_followers`. Rails will create
   join-table records for the new follows and remove records for
   unfollows. Note that this will only work if the parent object
   itself (the user) has been saved.

The second way is more convenient but also more magical. That's why
you must write things the first way first :-)

[guard-keys]: ./w4d1-ice-cream-finder.md#guard-dem-keys
