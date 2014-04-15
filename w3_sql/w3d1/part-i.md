# Learning SQL: Part I

First, read the SQL [intro][intro]. Then, read the [setup][setup]
instructions.

Your reading is chapters 3-5 in
[Learning SQL (2nd edition)][Learning-SQL] by Beaulieu. This will
teach you how to create tables and make queries against them.

[Learning-SQL]: http://www.amazon.com/Learning-SQL-Alan-Beaulieu/dp/0596520832
[setup]: ./setup.md
[intro]: ./sql-intro.md

### Reading suggestions

The book sometimes (briefly) discusses the differences between MySQL
vs other relational database implementations. You can safely ignore
these comments.

**Make sure to type out and execute all of the SQL statements in the
book (using the Postgres database you set up).** It's important to do this to learn the syntax of SQL.

### SQL Conventions

Different programmers use different SQL conventions, but in
preparation for ActiveRecord and Rails, which have their own
conventions, you should:

* Always name SQL tables **snake\_case** and
  **pluralized**. (e.g., `musical_instruments`, `favorite_cats`)
* If a `musician` belongs to a `band`, your `musicians` table will
  need to store a foreign key that refers to the `id` column in the
  `bands` table.  The foreign key column should be named `band_id`.
* Always have a column named `id`, and use it as the primary key for a
  table.

## Reading questions

*NB: Make sure you can answer these, but no need to write out answers.*

### Ch 3
* 3.1
  * What is a database connection and how long is it held?
  * What is the *query optimizer*?
* 3.2
  * Be able to describe the purpose of the `SELECT`, `FROM`, `WHERE`,
    `GROUP BY`, `HAVING` and `ORDER BY` clauses. Don't worry about
    memorizing the definitions in this section now, but you should have
    internalized them by the time you've finished this chapter.
* 3.3
  * How do you add column aliases to a `SELECT` clause?
  * How do you remove duplicates from a `SELECT` clause?
    * Why does this make the query slower?
* 3.4
  * What is a *subquery*?
  * What does a *subquery* generate (or return)?
  * What is a *view*?
  * How do you create an alias for a table?
* 3.5
  * Know how to write simple `WHERE` clauses with multiple filter
    conditions. Know how to group conditions with parentheses.
* 3.7
  * How do you order on multiple columns (i.e., first on one column,
    then on another)?
  * What is the default sorting order, and how do you flip it?
  * How do you sort via an expression?

### Ch 4
* 4.1
  * Be familiar with the `NOT` operator.
* 4.3
  * Be familiar with the following types of conditions:
    equality/inequality, range (incl. the `BETWEEN` operator),
    membership (the `IN` operator, via subqueries, `NOT IN`)
  * Skip Section 4.3.4.1 (Wildcards).
  * Know how to use regex in a search expression.
* 4.4
  * How do you test if an expression is `NULL`?
  * How do you test if a value has been assigned to a column?

### Ch 5
* 5.1
  * What is a cross join and how is it generated?
  * What is an inner join and how is it generated?
  * What is the default type of join?
  * Skip 5.1.3 (ANSI Join Syntax)
* 5.2
  * Know how to inner join 3 (or more) tables. Know how to inner join
    to the same table multiple times.
* 5.3
  * What is a self-referencing foreign key?
  * How do you inner join a table to itself?
* 5.4
  * How do you inner join a table to another on a range of values
    instead of on an equality condition? How do you do that for a
    self-join?
* 5.5
  * As you know, join conditions belong in the `ON` clause and filter
    conditions belong in the `WHERE` clause. What happens if you put a
    join condition in the `WHERE` clause and/or a filter condition in
    an `ON` clause?

### SQL FAQ

**Q**: Isn't a CROSS JOIN the same as a regular JOIN without the ON clause?

**A**: Yup! But Nota Bene some SQL implementations always require an ON clause for regular JOIN.

**Q**: How do you make comments in SQL?  It doesn't seem to respect the #.

**A**: You can use /* Your comments go Here */

**Q**: The MySQL conversion command 'YEAR(start_date) start_year' doesn't seem to work in Postgres. 
       I get an error saying 'You might need to add explicit type casts'. Is this a problem with my system or is 
       the syntax different for Postgres?
       
**A**: You can use the EXTRACT function. In this instance, you would use 'EXTRACT(YEAR FROM start_date) start_year'
