## Reading questions

### Ch 1
* 1.1
  * What is a *primary key*?
  = One or more columns that can be used as a unique identifier for each row in a table.

  * What is a *foreign key*?
  = One or more columns that can be used together to identify a single row in another table.

  * What is a *compound key*?
  = A primary key consisting of two or more columns

  * What is *normalization*?
  = The process of refining a database design to ensure that each independent piece of information is in only one place (except for foreign keys)

* 1.2
  * What is the result of an SQL query?
  = Result set, a non persistent table

  * What is an SQL schema statement?
  = used to define the data structures stored in the database

  * What is an SQL data statement?
  = used to manipulate the data structures previously defined using SQL schema statements

  * What is an SQL transaction statement?
  = used to begin, end, and roll back transactions

### Ch 2
* 2.3
  * How do you define a fixed-length string up to 20 characters long?
  = char(20)

  * How do you define a variable-length string up to 20 characters
    long?
  = varchar(20)

  * What happens if the data being loaded into a text column exceeds
    the maximum size for that type?
  = truncated

* 2.4
  * What command is used to look at the table definition (or *schema*)
    of a table?
  = DESC tablename;

  * What is `NULL`?
  = indicates the absence of a value (not applicable/unknown/empty set)

* 2.5
  * What are the three main components of an `INSERT` statement?
  = table name, columns to populate, values to populate columns

  * Why should you not provide values for numeric primary keys and
    instead let the database provide the value for you?
  = race conditions/collisions, multiple clients using the database

  * Write and execute a query that selects the people (id, fname, lname
    & birthdate) from the `person` table (defined in the book) that
    have a first name of 'William'.

    SELECT person_id, fname, lname, birth_date
    FROM person
    WHERE fname = "William"

  * Insert a row with your information into the person table. Leave out
    your address. Write a second (separate) statement that updates the
    row that contains your information with your address.

    INSERT INTO person
    (fname, lname, gender, birth_date)
    VALUES ('William','Turner', 'M', '1972-05-27');

    UPDATE person
    SET street = '1225 Tremont St.',
        city = 'Boston',
        state = 'MA',
        country = 'USA',
        postal_code = '02138'
    WHERE person_id = 1;

  * What happens if you you write an update statement, but leave off
    the where clause?
  = Everything gets updated

  * Write and execute a statement deleting yourself from the person
    table.

    DELETE FROM person
    WHERE person_id = 2;

### Ch 3
* 3.1
  * What is a database connection and how long is it held?
  = Connection to the database? Gets held until requesting application releases the connection or the server closes it.

  * What is the *query optimizer*?
  = The query optimizer determines the most efficient way to execute your query. The optimizer will look at such things as the order in which to join the tables named in your from clause and what indexes are available, and then picks an execution plan, which the server uses to execute your query.

* 3.2
  * Be able to describe the purpose of the `SELECT`, `FROM`, `WHERE`,
    `GROUP BY`, `HAVING` and `ORDER BY` clauses. Don't worry about
    memorizing the definitions in this section now, but you should have
    internalized them by the time you've finished this chapter.

  SELECT -> determines which of all possible columns should be included in the
query's result set
  FROM -> the tables to use
  WHERE -> conditions to filter out unwanted data
  GROUP BY -> group rows together by common column values
  HAVING -> filters out unwanted groups
  ORDER BY -> sorts the rows of the final result set by one or more columns

* 3.3
  * How do you add column aliases to a `SELECT` clause?
  SELECT something s
  SELECT something AS s

  * How do you remove duplicates from a `SELECT` clause?
  = use SELECT DISTINCT

  * Why does this make the query slower?
  = The database first has to sort the result set to throw out the duplicates. For a large result set this can be slow.

* 3.4
  * What is a *subquery*?
  = A query contained within another query

  * What does a *subquery* generate (or return)?
  = Temporary table

  * What is a *view*?
  = A query that is stored in the data dictionary. It looks and acts like a table, but there is no data associated with a view (this is why I call it a virtual table).

  * How do you create an alias for a table?
  FROM table AS t
  FROM table t

* 3.5
  * Know how to write simple `WHERE` clauses with multiple filter
    conditions. Know how to group conditions with parentheses.
  WHERE fname = "Jonathan" AND (lname = "Nieder" OR lname = "Tamboer")

* 3.7
  * How do you order on multiple columns (i.e., first on one column,
    then on another)?
  ORDER BY column1, column2

  * What is the default sorting order, and how do you flip it?
  = Default is ASC
  ORDER BY column1 DESC

  * How do you sort via an expression?
  = Ya just throw it in there
  ORDER BY RIGHT(column1, 3)
  or
  ORDER BY 2, 5
  this takes the second and fifth column from the select clause

### Ch 4
* 4.1
  * Be familiar with the `NOT` operator.
* 4.3
  * Be familiar with the following types of conditions:
    equality/inequality, range (incl. the `BETWEEN` operator),
    membership (the `IN` operator, via subqueries, `NOT IN`)
  * Skip Section 4.3.4.1 (Wildcards).
  _ = wildcard for one character
  % = wildcard for 0 or more characters
  * Know how to use regex in a search expression.
  WHERE fname REGEXP "^J[aeoui]n"
* 4.4
  * How do you test if an expression is `NULL`?
  Null is absence of value
  An expression can be null, but it can never equal null.
  Two nulls are never equal to each other

  IS NULL

  WHERE column IS NULL

  This does *NOT* work:
  WHERE column = NULL




  * How do you test if a value has been assigned to a column?
  IS NOT NULL

### Ch 5
* 5.1
  * What is a cross join and how is it generated?
  = Joins every row of the specfied tables to each other, also called Cartesian join
  JOIN without an ON or USING clause

  * What is an inner join and how is it generated?
  = Intersection of the from table and the join table

  SELECT *
  FROM table1
  JOIN table2
  ON table1.column_id = table2.column_id

  If the columns used to join the two tables are identical, you can use USING instead of ON

  SELECT *
  FROM table1
  JOIN table2
  USING(column_id)

  * What is the default type of join?
  INNER JOIN



  * Skip 5.1.3 (ANSI Join Syntax)
* 5.2
  * Know how to inner join 3 (or more) tables. Know how to inner join
    to the same table multiple times.

  SELECT *
  FROM table1
  INNER JOIN table2
  ON table1.column1 = table2.column1
  INNER JOIN table 3
  ON table1.column2 = table3.column2

* 5.3
  * What is a self-referencing foreign key?
  A self-referencing foreign key is a column that points to the primary key within the same table

  * How do you inner join a table to itself?

  SELECT *
  FROM table t1
  INNER JOIN table t2
  ON t1.related_id = t2.id

* 5.4
  * How do you inner join a table to another on a range of values
    instead of on an equality condition? How do you do that for a
    self-join?
  = Do stuff in the ON clause

  SELECT *
  FROM table1
  INNER JOIN table2
  ON table1.column1 > table2.column1

  SELECT *
  FROM table t1
  INNER JOIN table t2
  ON t1.id < t2.id

* 5.5
  * As you know, join conditions belong in the `ON` clause and filter
    conditions belong in the `WHERE` clause. What happens if you put a
    join condition in the `WHERE` clause and/or a filter condition in
    an `ON` clause?
  = Still works, but not clear, do not do this.

-------------------

### Ch 8
* 8.1
  * How do you `GROUP BY` a specific column?

  SELECT *
  FROM table
  GROUP BY column


  * Why can't you use a `WHERE` clause to filter a group returned by
    `GROUP BY`?
  = The GROUP BY clause runs after the WHERE clause has been evaluated, you cannot add filter conditions to your WHERE clause

  * How does `WHERE` interact with `GROUP BY`?
  = Aggregate functions don't work in WHERE clause, because the groups have not yet been generated at the time the WHERE clause is evaluated

  * What should you use instead to achieve the same type of
    filtering?
  = HAVING

  SELECT *
  FROM table
  GROUP BY column
  HAVING COUNT(*) > 4

* 8.2
  * What is an *aggregate function*?
  = Aggregate functions perform a specific operation over all rows in a group.
  MAX MIN AVG SUM COUNT

  * Understand the explicit grouping covered in 8.2.1.
  = If there is no GROUP BY clause, there is a single, implicit group (all rows returned by the query).


  * How do you count distinct values for a column across all members of
    the group?

  SELECT COUNT(DISTINCT column)
  FROM table

  * How is `NULL` handled by aggregate functions?
  = Aggregate functions don't care.
  However, count does.
  COUNT(*) includes rows with NULL in columns, because it counts rows
  COUNT(column) ignores columns with NULL, because it counts values in column


* 8.3
  * How do you group on a single column?

  SELECT *
  FROM table
  GROUP BY column

  * How do you group on multiple columns?

  SELECT *
  FROM table
  GROUP BY column1, column2

  * How do you group via expressions?

  SELECT *
  FROM table
  GROUP BY EXTRACT(YEAR FROM date_column)

  * What are "rollups" used for?
  It gives you summary statements for each group when using aggregate functions

### Ch 9
* 9.1
  * What is a *subquery*?
  = a query contained within another SQL statement

  * What is a *containing statement*?
  = the parent of the subquery

  * What is *statement scope*?
  = When the containing statement has finished executing, the data returned by any subqueries is discarded, making a subquery act like a temporary table with statement scope (meaning that the server frees up any memory allocated to the subquery results after the SQL statement has finished execution).


* 9.3
  * What is a *noncorrelated subquery*?
  = A subquery that is completely selfcontained

  * What is a *scalar subquery*?
  = A query that returns a table comprising a single row and column. It can appear on either side of a condition using the usual operators (=, <>, <, >, <=, >=)

  * What operator would you use to check if a single value can be found
    within a set of values?
  = IN and NOT IN

  SELECT *
  FROM table
  WHERE column IN (1, 2, 3)

  * What operator would you use to make comparisons between a single
    value and every value in a set?

  ALL

  SELECT *
  FROM table
  WHERE column > ALL(1, 2, 3)

  * What is the difference between the `ANY` and `ALL` operators?
   ANY evaluates to true as soon as a single value comparison is true. Different from ALL which evaluates to true only if all values compare true.

  * Be able to read and construct *multicolumn subqueries*.

  SELECT *
  FROM table
  WHERE (column1, column2) IN (SELECT column1, column1 FROM table)

* 9.4
  * What is a *correlated subquery*?
  A query dependent on its containing statement from which it references one or more columns.

  * What is the difference between a correlated subquery and a
    noncorrelated subquery?
  A noncorrelated subquery is executed once before the execution of the containing query.

  A correlated subquery is executed once for every row in the possible results.


  * What is the `EXISTS` operator used for?
  sees if a subquery has any rows

* 9.5
  * Can you use a subquery in a `FROM` clause? Can you use both
    correlated and noncorrelated subqueries in a `FROM` clause?
  You can use a subquery in a FROM clause, because it returns a temporary table. You can only use noncorrelated subqueries because there is no data yet to correlate.

  * Have an understanding of where you can (and might want to) use
    subqueries.

### Ch 10
* 10.1
  * What is an *outer join*?
  a join that doesn't drop rows from the left table if no match is found on the right table.

  * What is a *left outer join*?
  don't drop rows from the left table if no match

  * What is the difference between a *left outer join* and a *right
    outer join*?
  don't drop rows from the right or left table. You can rewrite a right outer join as a left outer join by changing the from and join tables around

  * Know how to outer join 3 or more tables.
  * Know how to perform *self outer joins*.
* 10.2
  * What is a *cartesian product* (or *cross join*)?
  everything with everything
* 10.3
  * What is a *natural join* and why should it be avoided?
  database picks the ON condition based on matching columns

-------------------

### Ch 13
* 13.1
  * What is a *database index*?
  A mechanism to find a particular item within a resource.

  Indexes are special tables that, unlike normal data tables, are kept in a specific order. Instead of containing all of the data about an entity, however, an index contains only the column (or columns) used to locate rows in the data table, along with information describing where the rows are physically located. Therefore, the role of indexes is to facilitate the retrieval of a subset of a tableâ€™s rows and columns without the need to inspect every row in the table.

  * Why would you want to create an index?
  you often look up rows based on a particular column. Indexing it will make it faster for the database to find it

  * What index is automatically created when you create a table?
  primary key

  * How do you enforce uniqueness of values in a particular column?
  add UNIQUE constraint

  * Why don't you need to build unique indices on your primary-key
    column(s) ?
  already done. primary key has to be unique

  * Why would you use a *multi-column index*?
  if you frequently search for something on multiple columns, it helps to sort those too.