# More on Querying

## Dynamic Finders

We've seen how to use `where` to retrieve an array of AR objects
matching some conditions. Sometimes, you want to find the single
object that matches some criteria; you want to dispense with the array
(which in this case will be either empty, or length 1). We use
**dynamic finders** for this:

```ruby
Application.find_by_email_address("ned@appacademy.io")
```

For any column `X` an AR model will respond to a message
`find_by_X`. To do this, AR overrides `method_missing?`. You can even
get crazy: `find_by_X_and_Y_and_Z`, passing three arguments.

Typically you only use up to two search criteria; if you need more
than two, just switch to `where` and then call `first` to get the
first item of the results array.

## `order`, `group`, and `having`

### Ordering

To retrieve records from the database in a specific order, you can use
the `order` method.

```ruby
Client.order("orders_count ASC, created_at DESC").all
```

### Group, Having

You can apply `GROUP BY` and `HAVING` clauses.

```ruby
UserPost
  .joins(:likes)
  .group("posts.id")
  .having("COUNT(*) > 5")
```

### Aggregations

You can perform all the typical aggregations:

* `Client.count`
* `Orders.sum(:total_price)`
* `Orders.average(:total_price)`
* `Orders.minimum(:total_price)`
* `Orders.maximum(:total_price)`

## Finding by SQL

We've seen how to get ActiveRecord to do fairly advanced stuff for us.

By the time I'd need these methods, I'd probably just use
`find_by_sql`, honestly. ActiveRecord has its limits; it's great for
reducing boilerplate SQL queries, but after a certain point you should
drop down and just use SQL yourself. Be flexible; don't expect too
much from ActiveRecord. Even if you have to drop to SQL for a few
monster queries, ActiveRecord has saved you a lot of work on all the
easy queries.

The main problem with trying to take ActiveRecord too far is that it
can become difficult to understand what kind of query it will generate
or how it will do what you ask. The more you ask ActiveRecord to do,
the more you have to trust that you express yourself properly, and the
more you have to think about whether ActiveRecord will do the right
thing. Sometimes simpler is better.

If you'd like to use your own SQL to find records in a table you can
use `find_by_sql`. The `find_by_sql` method will return an array of
objects. For example you could run this query:

```ruby
Case.find_by_sql(<<-SQL)
  SELECT
    cases.*
  FROM
    cases
  JOIN (
    // the five lawyers with the most clients
    SELECT
      lawyers.*
    FROM
      lawyers
    LEFT OUTER JOIN
      clients ON lawyers.id = clients.lawyer_id
    GROUP BY
      lawyers.id
    SORT BY
      COUNT(clients.*)
    LIMIT 5
  ) ON ((cases.prosecutor_id = lawyer.id)
         OR (cases.defender_id = lawyer.id))
SQL
```

Time to betray some ignorance: I don't know how I would do this with
AR and not SQL (or if it's possible!). At the very least I don't know
how I'd do it in one query.

Even if I spent the time to torture myself and figure it out, I'd only
be punishing the next person to read my code. Even if they understand
my intent, it'd be a dog to figure out whether I'm constructing the
query correctly in AR.

## References

* http://guides.rubyonrails.org/active_record_querying.html
