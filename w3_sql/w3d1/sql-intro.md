# SQL

## Databases

The Ruby objects you create during the lifetime of your program will
die when it closes. To save (or **persist**) data, you need to somehow
write the data to permanent storage, like the hard disk. We saw some
of this in the serialization chapter.

Applications usually also require rich relationships between pieces of
data. For a blogging system, users have many posts and posts have many
tags and users may be following other users and so on.

Relational databases (also sometimes referred to as RDBMS, relational
database management systems) were developed to provide a means of
organizing data and their relationships, persisting that data, and
querying that data.

## Tables

Relational databases organize data in tables.

| id            | name          | age  |
| ------------- | ------------- | ----- |
|1|John|22|
|2|James|24|
|3|Sally|54|
|4|Bob|48|
|5|Lucy|33|
|6|Mary|98|

Each row is a single entity in the table. Each column houses an
additional piece of data for that entity.

Every row in a database table will have a **primary key** which will
be its unique identifier in that table row. By convention, the primary
key is simply `id`. Most relational database systems have an
auto-increment feature to ensure that the primary keys are always
unique.

Breaking your domain down into database tables & columns is an
important part of developing any application. Each table will house
one type of resource: `people`, `houses`, `blog_posts`, etc. The
columns in the table will house the data associated with each instance
of the resource.

## Database Schemas

Your database **schema** is a description of the organization of
your database into tables and columns.

Designing your schema is one of the first and most important steps
when writing an application. It forces you to ask a basic but
essential question: what data does my application need to function?

When implementing a database schema, you must decide on three things:

* the tables you will have,
* the columns each of those tables will have,
* and the data type of each of those columns.

Schemas are mutable and so the decisions up front are not at all set
in stone. Still, you should spend time thinking about your schema at
the outset so you don't immediately make major, avoidable mistakes.

New to us is the concept of **static typing**. Ruby is **dynamically
typed**. for example, there is no need to specify in method parameters
or variables the class (also called **type**) of the data stored in
it. Ruby won't stop you even if you store something silly like a `Cat`
object in a variable named `favorite_dog`.

SQL is not quite so flexible; you must specify the type of data that
will go into each column.

Here are a few of the most common datatypes:

* `BOOLEAN`
* `INT`
* `FLOAT` (stores "floating point" numbers)
* `VARCHAR(255)` (essentialy a string with a length limit of 255
  chars)
* `TEXT` (a string of unlimited length)
* `DATE`
* `DATETIME`
* `TIME`
* `BLOB` (non-textual, binary data; e.g., an image)

We'll see how exactly we create tables and specify columns and column
types in just a bit.

## Modeling Relationships

So we have a way to store users and additional bits of data on them,
but how would we store associated entities like a blog post written
by a user?

Well, we probably have the sense that they should be in their own
tables since they're not really additional attributes on a user (which
would call for additional columns) nor are they users themselves
(which would call for additional rows). If posts were in their own
table, though, how would we know that they were associated with a
particular user?

We model these relationships between entries in separate tables
through ***foreign keys***. A foreign key is a value in a database
table whose responsibility is to point to a row in a different
table. Check out the posts table below (and pretend that people were a
bit more creative in their titles and bodies).

```
posts table:

id |   title   |     body    |  user_id
---------------------------------------
1  |  'XXXX'   |   'xyz...'  |    3
2  |  'XXXX'   |   'xyz...'  |    5
3  |  'XXXX'   |   'xyz...'  |    7
4  |  'XXXX'   |   'xyz...'  |    10
5  |  'XXXX'   |   'xyz...'  |    2
6  |  'XXXX'   |   'xyz...'  |    5

```

The `user_id` column is a foreign key column. If we wanted to find all
the posts for the user with `id` 5, we'd look in the posts table and
retrieve all the posts where the `user_id` column had a value of 5. If
you already know a little SQL:

```sql
SELECT
  *
FROM
  posts
WHERE
  posts.user_id = 5
```

By convention, the foreign key in one table will reference the primary
key in another table. We usually call the column that houses the
foreign key `[other_table_name_singularized]_id`.

Foreign keys are how we model relationships between pieces of data
across multiple tables. This also allows us to ensure that data is not
duplicated across our database. Posts live in a single place, users in
another, and the foreign key (`user_id`) in `posts` expresses the
relation between the one and the other.

## Structured Query Language (SQL)

So, now that we know what these tables look like and generally how
relationships are modeled between them, how do we actually get at the
data?

Enter SQL. SQL is a **domain-specific language** that's designed to
query data out of relational databases.

Here's a sample SQL query (we'll break it down in just a second):

```sql
-- Find crazy cat people
SELECT
  name, age, has_cats
FROM
  tenants
WHERE
  (has_cats = true AND age > 50)
```

SQL queries are broken down into clauses. Here, there is the `SELECT`
clause, the `FROM` clause, and the `WHERE` clause. `SELECT` takes a
list of comma-separated column names; only these columns of data will
be retrieved. `FROM` takes a table name to query. `WHERE` takes a list
of conditions separated by `AND` or `OR`; only rows matching these
conditions are returned..

SQL provides powerful filtering with `WHERE`; it supports the standard
comparison and equality operators (`<`, `>`, `>=`, `<=`) as well as
grouping the logical operators (`AND`, `OR`, `NOT`).

There are 4 main data manipulation operations that SQL provides:

* `SELECT`: retrieve values from one or more rows
* `INSERT`: insert a row into a table
* `UPDATE`: update values in one or more existing rows
* `DELETE`: delete one or more rows

Below are brief descriptions of each of the operators syntactical
signatures and a couple simple examples of their use:

### `SELECT`

**Structure:**

```sql
SELECT
  one or more columns (or all columns with *)
FROM
  one (or more tables, joined with JOIN)
WHERE
  one (or more conditions, joined with AND/OR);
```

**Examples:**

```sql
SELECT
  *
FROM
  users
WHERE
  name = 'Ned';

SELECT
  account_number, account_type
FROM
  accounts
WHERE
  (customer_id = 5 AND account_type = 'checking');
```

### `INSERT`

**Structure:**

```sql
INSERT INTO
  table name (column names)
VALUES
  (values);
```

**Examples:**

```sql
INSERT INTO
  users (name, age, height_in_inches)
VALUES
  ('Santa Claus', 876, 34);

INSERT INTO
  accounts (account_number, customer_id, account_type)
VALUES
  (12345, 76, 'savings');
```

### `UPDATE`

**Structure:**

```sql
UPDATE
  table_name
SET
  col_name1 = value1,
  col_name2 = value2
WHERE
  conditions
```

**Examples:**

```sql
UPDATE
  users
SET
  name = 'Eddard Stark', house = 'Winterfell'
WHERE
  name = 'Ned Stark';

UPDATE
  accounts
SET
  balance = 30
WHERE
  id = 6;
```

### `DELETE`

**Structure:**

```sql
DELETE FROM
  table_name
WHERE
  conditions
```

**Examples:**

```sql
DELETE FROM
  users
WHERE
  (name = 'Eddard Stark' AND house = 'Winterfell');

DELETE FROM
  accounts
WHERE
  customer_id = 666;
```

## Schema Definitions

Before basic querying can take place though, you need to actually
define your database schema. There are three operators that SQL
provides to manipulate a database schema:

* `CREATE TABLE`
* `ALTER TABLE`
* `DROP TABLE`

Here's an example of creating a users table (we'll break it down
shortly):

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  birth_date DATE,
  house VARCHAR(255),
  favorite_food VARCHAR(20)
);
```

`CREATE TABLE` first specifies the name of the table, and then in
parantheses, the list of column names along with their data types.

## Querying across multiple tables (JOIN)

If we've specified a bunch of foreign keys in many tables, at some
point, we'll want to access that rich relational data. So far we've
only seen ways to query a single table. How might we query across
tables?

SQL provides a powerful facility to do so: the `JOIN`. A `JOIN` will
do just what you'd expect it to do: it joins together two tables. With
`ON`, you specify how exactly those two tables relate to one another.
This is where the foreign key comes in. Check out the simple join
below.

Let's write a query that returns the title of all the blog posts
written by each user:

```sql
SELECT
  user.name, posts.title
FROM
  posts
JOIN
  users ON posts.user_id = users.id
```

This will return one row per post, with the user's name appearing next
to the title of the post they authored.

## Resources

* [Intro Video][youtube-dbclass]

[youtube-dbclass]: http://www.youtube.com/watch?v=wxFmiRwXcQY
