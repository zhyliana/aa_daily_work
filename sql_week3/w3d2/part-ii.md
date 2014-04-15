# Learning SQL: Part II

Part II is to read ch8-10 and ch13.2 in
[Learning SQL (2nd edition)][Learning-SQL] by Beaulieu. This will
teach you how to write more sophisticated queries, especially queries
that combine information from across tables.

Do not read chapters six and seven.

## Reading questions

### Ch 8
* 8.1
  * How do you `GROUP BY` a specific column?
  * Why can't you use a `WHERE` clause to filter a group returned by
    `GROUP BY`?
    * How does `WHERE` interact with `GROUP BY`?
    * What should you use instead to achieve the same type of
      filtering?
  * How many rows are returned from a single group?
  * What kinds of columns are you allowed to select when performing a
    `GROUP BY`?
* 8.2
  * What is an *aggregate function*?
  * Understand the explicit grouping covered in 8.2.1.
  * How do you count distinct values for a column across all members of
    the group?
  * How is `NULL` handled by aggregate functions?
* 8.3
  * How do you group on a single column?
  * How do you group on multiple columns?
  * How do you group via expressions?
  * What are "rollups" used for?

### Ch 9
* 9.1
  * What is a *subquery*?
  * What is a *containing statement*?
  * What is *statement scope*?
* 9.3
  * What is a *noncorrelated subquery*?
  * What is a *scalar subquery*?
  * What operator would you use to check if a single value can be found
    within a set of values?
  * What operator would you use to make comparisons between a single
    value and every value in a set?
  * What is the difference between the `ANY` and `ALL` operators?
  * Be able to read and construct *multicolumn subqueries*.
* 9.4
  * What is a *correlated subquery*?
  * What is the difference between a correlated subquery and a
    noncorrelated subquery?
  * What is the `EXISTS` operator used for?
* 9.5
  * Can you use a subquery in a `FROM` clause? Can you use both
    correlated and noncorrelated subqueries in a `FROM` clause?
  * Have an understanding of where you can (and might want to) use
    subqueries.

### Ch 10
* 10.1
  * What is an *outer join*?
  * What is a *left outer join*?
  * What is the difference between a *left outer join* and a *right
    outer join*?
  * Know how to outer join 3 or more tables.
  * Know how to perform *self outer joins*.
* 10.2
  * What is a *cartesian product* (or *cross join*)?
* 10.3
  * What is a *natural join* and why should it be avoided?

### Ch 13
* 13.1
  * What is a *database index*?
  * Why would you want to create an index?
  * What index is automatically created when you create a table?
  * How do you enforce uniqueness of values in a particular column?
  * Why don't you need to build unique indices on your primary-key
    column(s) ?
  * Why would you use a *multi-column index*?
  * Understand broadly the structure and balancing nature of a *balanced-tree* or *B-tree*.
  * Extra-Credit: 13.1.2.2
  * Play around with the `explain` statement a bit to see how your
    queries get executed
  * Why not index every column?
* 13.2
  * What is a *constraint*?
  * What is a *foreign-key constraint*?

[Learning-SQL]: http://www.amazon.com/Learning-SQL-Alan-Beaulieu/dp/0596520832/

## Bonus

* [Use the Index Luke][use-the-index]: bonus material on query
  optimization for after the course.

[use-the-index]: http://use-the-index-luke.com/
