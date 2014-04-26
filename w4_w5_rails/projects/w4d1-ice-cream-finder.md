# Ice Cream Finder

Estimated time: 1hr 30min.

Write a script that takes your current location and finds nearby ice
cream shops. It should provide directions to walk there.

You may want to use a number of Google APIs:

* [Places API][places-api]: given a search string and a
  latitude-longitude, finds and describes nearby matching locations.
* Maps API
    * [Geocoding][geocoding-api]: given a text description of the
      current location, returns a latitude and longitude.
    * [Directions API][directions-api]: given two addresses or
      lat/lngs, returns a series of directions between the two places.

Head on over to the [Google APIs Console][api-console]. Create a
project. Click "APIs & auth". You'll want to turn on the relevant
APIs.

You'll need an application key to access the Places API. Click
"Registered apps" under "APIs & auth". Then click "Register App". Name
it anything and pick "Web Application".

You'll get a variety of keys, but the one you want is the server
key. The documentation examples will show how to use it.

[api-console]: https://cloud.google.com/console

## Hints

### JSON Formatter

This project will likely require tons of time spent staring at a 
tsunami of JSON data. This is extremely tedious and wastes precious
time. Use Google Chrome and install the Chrome extension [JSON Formatter][JSON-ext].

This will greatly improve the display of the JSON data on chrome.
You will be able to collapse data and understand the structure with
the greatest of ease, sort of. Anyway, install it. It will make the
rest of your life easier. You will use it as we learn backbone.
You will use it on your final project. You will probably use it
every day after you leave a/A and get a job in the real world.

[JSON-ext]: https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en

### Guard 'Dem Keys!

You never want to upload any secret keys (e.g. an API key) to GitHub.
Nefarious folks write scripts to search GitHub repos for private keys,
credentials, etc. You don't want them finding your keys and using up
your data limit, posting things as you, or whatever.

So a good practice is to save your key somewhere that isn't version
controlled. Later, you'll learn about a great Rails gem called Figaro
that makes this easy. For now, you can simply save your key in a separate
file and add that file to your project's `.gitignore` file. Here, I load
a file called `.api_key` from within my program:

```ruby
api_key = nil
begin
  api_key = File.read('.api_key').chomp
rescue
  puts "Unable to read '.api_key'. Please provide a valid Google API key."
  exit
end
```

Then in my `.gitignore`, I add the line:

```
.api_key
```

Then I merely need to make the contents of `.api_key` my actual key string.

### Request denied

Make sure you have generated an API key and turned on the appropriate
services. You may also want to verify you are using the proper scheme:
if you are sending an API key, Google will probably force you to use
HTTPS to protect against eavesdroppers stealing your key.

### `Addressable::URI`

**Use Addressable::URI**, described in the APIs chapter. Do not build
query strings by hand! That is ugly and error-prone! Don't waste time
by subbing "+" or "," in your query strings. You can pass
`Addressable::URI` a `query_values` option.

### Nokogiri

You may wish to use [Nokogiri][nokogiri] to strip out the HTML tags
from Google Directions instructions. Nokogiri parses HTML into Ruby
objects that you can call methods on.

```ruby
require 'nokogiri'
parsed_html = Nokogiri::HTML("This is <b>bold</b> text!")
parsed_html.text
# => "This is bold text!"
```

[places-api]: https://developers.google.com/places/documentation/search
[geocoding-api]: https://developers.google.com/maps/documentation/geocoding/
[directions-api]: https://developers.google.com/maps/documentation/directions/

[nokogiri]: http://nokogiri.org/
