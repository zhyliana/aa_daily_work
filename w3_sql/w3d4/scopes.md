# Scopes

It's common to write commonly used queries as a **scope**. A scope is
just a fancy name for an `ActiveRecord::Base` class that returns a
`Relation`.

```
class Post < ActiveRecord::Base
  def self.most_popular_posts
    self
      .select("posts.*, COUNT(*) AS comment_count")
      .joins(:comments)
      .group("posts.id")
  end
end
```

Of course, we can now write `Post.most_popular_posts`. Through a bit
of Rails magic, we may also write `user.posts.most_popular_posts`:

```
irb(main):001:0> Post.most_popular_posts
  Post Load (13.9ms)  SELECT posts.*, COUNT(*) AS comment_count FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" GROUP BY posts.id
=> #<ActiveRecord::Relation [#<Post id: 1, title: "First Post", body: "BODY BODY BODY", author_id: 1, created_at: "2013-12-06 18:36:30", updated_at: "2013-12-06 18:36:30">]>
irb(main):002:0> User.first.posts.most_popular_posts
  User Load (1.1ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
  Post Load (3.7ms)  SELECT posts.*, COUNT(*) AS comment_count FROM "posts" INNER JOIN "comments" ON "comments"."post_id" = "posts"."id" WHERE "posts"."author_id" = $1 GROUP BY posts.id  [["author_id", 1]]
=> #<ActiveRecord::AssociationRelation [#<Post id: 1, title: "First Post", body: "BODY BODY BODY", author_id: 1, created_at: "2013-12-06 18:36:30", updated_at: "2013-12-06 18:36:30">]>
```

You've read about the `Relation` class. `user.posts` returns a
`Relation`. Because `Relation` contains `Post` objects, ActiveRecord
is smart and will copy the `Post` class methods so that we can call
them directly on the `Relation`. Because inside `::most_popular_posts`
call `select`/`joins`/`group` on `self`, when we call the method on
`Relation` we will construct a relation that further filters the
`posts` of the `user`.

Use scopes to keep your query code DRY: move frequently-used, queries
into a scope. It will also make things much more readable by giving a
convenient name of your choosing to the query.
