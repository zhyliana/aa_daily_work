# Heredocs

We know how to format SQL code in a `.sql` file, but what if we mix
SQL into our Ruby code? The answer is to use a **heredoc** to write
multi-line strings with ease:

```ruby
query = <<-SQL
SELECT
  *
FROM
  posts
JOIN
  comments ON comments.post_id = posts.id
SQL

db.execute(query)
```

This replaces `<<-SQL` with the text on the next line, up to the closing
`SQL`. We could use any string for the start and end of a heredoc; `SQL`
is just the convention when we are embedding SQL code.

A heredoc produces a string just like quotes does, and it will return
into the place where the opening statement is. For example, this works
as well:

```ruby
db.execute(<<-SQL, post_id)
SELECT
  *
FROM
  posts
JOIN
  comments ON comments.post_id = posts.id
WHERE
  posts.id = ?
SQL
```

Notice the use of the `?` interpolation mark; the Ruby variable
`post_id` will be inserted into the query at the `?`.

## References

* [More on heredocs][heredocs]

[heredocs]: https://makandracards.com/makandra/1675-using-heredoc-for-prettier-ruby-code
