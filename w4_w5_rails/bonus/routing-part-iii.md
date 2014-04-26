# Routing III: Adding non-default routes

You are not limited to the seven routes that RESTful routing creates
by default. If you like, you may add additional routes that apply to
the collection or individual members of the collection.

## Adding Member Routes

To add a member route, just add a `member` block into the resource
block:

```ruby
resources :photos do
  member do
    get 'preview'
  end
end
```

A GET request for `/photos/1/preview` will be routed to the `preview`
action of `PhotosController`. It will also create a
`preview_photo_url` helper.

Within the block of member routes, each route name specifies the HTTP
verb that it will recognize. You can use `get`, `post`, `put`, or
`delete` here.

## Adding Collection Routes

To add a route to the collection:

```ruby
resources :photos do
  collection do
    get 'search'
  end
end
```

This will enable Rails to recognize paths such as `/photos/search`
with GET, and route to the `search` action of `PhotosController`. It
will also create a `search_photos_url` helper.

## A Note of Caution

Don't go crazy and start adding lots of new, non-default routes. That
is almost certainly wrong.

Try to do things the RESTful way. In particular, each time you add a
new, custom controller action (a new "verb"), think about whether you
could instead introduce a new resource using the conventional verbs.

REST turns object-oriented programming on its head a bit. Instead of
adding new methods so that our objects can do more and more things, we
keep adding new resources that all do the same things.

Later we'll talk about why this is a desirable approach. For now, feel
a sense of foreboding each time you add a new, non-RESTful route. Ask
your TA about each.
