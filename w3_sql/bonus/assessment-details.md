# ActiveRecord Assessment

This is a list of the most important concepts to have learned about
ActiveRecord in preparation for our assessment on it:

* How to decompose a problem into tables
* How to use migrations to setup tables
* How to write model classes
* How to set up `belongs_to`/`has_one`/`has_many` associations between them
    * You need to know when to use `belongs_to` vs
      `has_one`/`has_many`.
* How to set up validation logic
    * Presence, uniqueness, scopes, and custom validation
* How to fetch items from a table using `find` and `where`
* How to use `includes` to avoid N+1 selects.
* How to use `joins` and `group` to do queries that *aggregate* data.

It is *not vital* to yet understand

* Indices
* Constraints
