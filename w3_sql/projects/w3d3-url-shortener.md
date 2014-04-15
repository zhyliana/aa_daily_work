# URL Shortener: Part SQL

In this project, we build a tool that will take an input URL and will
shorten it for the user. Subsequent users can then give the shortened
URL back to the application and be directed to the original URL.

We'll eventually make a web-app version of this, but for now let's
input shortened URLs into a Command Line Interface
([CLI][what-is-cli]) and use the launchy gem to pop open the original
URL in a browser.

## Phase I: `User`

Start with `rails generate migration CreateUsersTable` to create a 
migration to create the `users` table. This table needs only one column
in a addition to the ever present `t.timestamps`, and that is `email`.
Index the column for fast sorting and enforce that this is unique 
using a database constraint. Searching for 'unique' in 
[this document will help](http://api.rubyonrails.org/classes/ActiveRecord/Migration.html)

Next, let's create a `User` model. No magic to this, just create a `user.rb` file
in your `app/models` folder. 

Look at the validations chapter and require the email to be present
and unique (at the model level). If we didn't do this, we could have people
creating user accounts without emails. We cannot allow this.

**NB: the naming of your files is essential. When you try to create an instance
of a model, it looks in the models folder for a file that is the 
`snake_case`ified version of your model's name. Also, it will, by default, 
infer that the name of the table is the pluralized, snake cased, version of your
model. For example, if I had a `GoodStudent` model, rails would look in the
`app/models` folder for a file called `good_student.rb`. Upon finding and loading
this file, it would create an instance of the class with data from a table it
assumes to be `good_students`. If your naming doesn't _EXACTLY_ follow convention,
you're gonna have a bad time.**


## Phase II: `ShortenedUrl`

### Basic structure

Create a `shortened_urls` table and write a `ShortenedUrl` model. Store 
both the `long_url` and `short_url`s. Also store the id of the user 
who submitted the url.

Add indices to look up a `ShortenedUrl` by `submitter_id` (to find
urls owned by a user), and by `short_url` (user will type in the short
url, we'll want to look up the long version). Which index should be
unique?

Again, add uniqueness and presence validations.

### Why no `LongUrl` model?

We **could** factor out the `long_url` to its own model, `LongUrl`,
and store in the `ShortenedUrl` a key to the `LongUrl`. If the URLs
are super long this would reduce memory usage by not repeating the
long url in every shortened url. On the other hand, the long url is
already an ID, so it's not improper to duplicate, plus factoring it
out into its own table will force two steps of lookup to resolve a
short URL:

0. Find the `ShortenedUrl` model
0. Find the associated `LongUrl`.

For this reason, we can expect better performance by storing the long
url in the `shortened_urls` table.

### `ShortenedUrl::random_code`

Now it's time for us to actually shorten a URL for the users. We do this by
generating a random, easy to remember, 16 character random code and storing
this code as the `short_url` in our table. Now, we can search for this record
by the `short_url` and we get the `long_url`.

We will be generating a random string with
`SecureRandom::urlsafe_base64`. In [Base64 encoding][wiki-base64],
each character of the string is chosen from one of 64 possible
letters. That means there are `64**16` possible base64 strings of
length 16.

Write a method, `ShortenedUrl::random_code` that uses 
`SecureRandom::urlsafe_base64` to generate a 16 letter random code. 
Handle the vanishingly small possibility that a code has already been 
taken: keep generating codes until we find one that isn't the same as one
already stored as the `short_url` of any record in our table. Return the 
first unused random code. 

[wiki-base64]: http://en.wikipedia.org/wiki/Base64

### `ShortenedUrl::create_for_user_and_long_url!(user, long_url)`

Write a factory method that takes a `User` object and a `long_url`
string and `create!`s a new `ShortenedUrl`.

### Associations and testing

Write `submitter` and `submitted_urls` associations to `ShortenedUrl`
and `User`.

Go ahead and in the Rails console create some `User`s and some
`ShortenedUrl`s. Check that the associations are working.

## Phase III: Tracking `Visit`s

### Model

We want to track how many times a shortened URL has been visited. We
also want to be able to fetch all the `ShortenedUrl`s a user has
visited.

To accomplish this, write a `Visit` join table model. Add appropriate
indices and validations.

### `Visit::record_visit!(user, shortened_url)`

Add a convenience factory method that will create a `Visit` object
recording a visit from a `User` to the given `ShortenedUrl`.

### Associations

Write `visitors` and `visited_urls` associations on `ShortenedUrl` and
`User`. These associations will have to traverse associations in
`Visit`. Define appropriate associations in `Visit`; what kind of
association can traverse other associations?

Next: What if a visitor has visited a url many times, and you call the
`visitors` method on that `url` instance?  Could the same user be
returned multiple times in the result array?  How do you fix this?

Hint: This is an extremely common problem. Look up the `:distinct` 
option for a `has_many` association.


### `ShortenedUrl#num_clicks`, `#num_uniques`, `#num_recent_uniques`

Write a method that will count the number of clicks on a
`ShortenedUrl`. Likewise, write a method that will determine the
number of distinct users who have clicked a link. 
[Read about how to use][count-distinct-docs]
`#count`'s `:distinct` option.

Lastly, count only unique clicks in a recent time period (say, 
`10.minutes.ago`).

## Phase IV: A simple CLI

Write a very simple command-line interface in `bin/cli` (the 
convention for rails scripts is to omit the extension `.rb`). Add 
these features:

* Ask the user for their email; find the `User` with this email. You
  don't have to support users signing up through the CLI.
* Give the user the option of visiting a shortened URL or creating
  one.
* When they create a new short URL, return to the user the short url.
* Use the `launchy` gem to open a URL in the browser; record a visit.

Here's a demo:

```
~/repos/appacademy-solutions/URLShortener$ rails runner bin/cli
Input your email:
ned@appacademy.io
What do you want to do?
0. Create shortened URL
1. Visit shortened URL
0
Type in your long url
http://www.appacademy.io
Short url is: Pm6T7vWIhTWfMzLaT02YHQ
~/repos/appacademy-solutions/URLShortener$ rails runner bin/cli
Input your email:
ned@appacademy.io
What do you want to do?
0. Create shortened URL
1. Visit shortened URL
1
Type in the shortened URL
Pm6T7vWIhTWfMzLaT02YHQ
~/repos/appacademy-solutions/URLShortener$ rails c
Loading development environment (Rails 3.2.11)
1.9.3-p448 :001 > ShortenedUrl.find_by_short_url("Pm6T7vWIhTWfMzLaT02YHQ").visits
  ShortenedUrl Load (0.1ms)  SELECT "shortened_urls".* FROM "shortened_urls" WHERE "shortened_urls"."short_url" = 'Pm6T7vWIhTWfMzLaT02YHQ' LIMIT 1
  Visit Load (0.1ms)  SELECT "visits".* FROM "visits" WHERE "visits"."shortened_url_id" = 1
 => [#<Visit id: 1, user_id: 1, shortened_url_id: 1, created_at: "2013-08-18 19:15:55", updated_at: "2013-08-18 19:15:55">]
```

The `rails runner` command will **load the Rails environment** which
means you'll be able to use your classes without requiring
them. Importantly, `rails runner` will also connect to the DB so you
can query tables.

**Your script should only contain UI code, and UI code should always
go in your script**. Suppose you want to write a web version of
this program soon. The stuff in your CLI script can't be reused in the web
version. Moreover, your model will be dependent on the offline CLI
script and may break when you make a web interface. Avoiding this
situation is a very conventional case of **separation of concerns**.

## Bonus Phase

###  `TagTopic`, `Tagging`s

Users should be able to choose one of a set of predefined `TagTopic`s
for links (news, sports, music, etc.). You should be able to query for
the most popular links in each category. NB: the relationship between
`TagTopic`s and `URL`s is many-to-many. You'll need a join model like
`Tagging`s.

### More validations

* Length of URL strings < 1024 (or whatever your varchar length is).
* A custom validation that no more than 5 urls are submitted in the
  last minute by one user.

[what-is-cli]: http://www.techopedia.com/definition/3337/command-line-interface-cli
[count-distinct-docs]: http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html#method-i-count
