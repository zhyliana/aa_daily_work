# Formatting SQL Code

You must not write SQL all on a single line. It will be impossible to
read:

    SELECT * FROM table_one LEFT OUTER table_two ON table_one.column_one = table_two.column_x WHERE (table_one.column_three > table_two.column_y ...

Here's an example of some well formatted SQL code:

```sql
SELECT
  table_two.column_one,
  table_two.column_two,
  table_two.column_three
FROM
  table_one
LEFT OUTER JOIN
  table_two ON table_one.column_one = table_two.column_x
WHERE
  (table_one.column_three > table_two.column_y
    AND another_condition IS NULL)
GROUP BY
  table_two.column_four
ORDER BY
  table_two.column_four
```

Notice that each component of the SQL statement starts with the
keyword aligned left. The body of each component is indented two
spaces. Complex `WHERE` clauses are parenthesized and indented two
spaces on the follow line.

## Subqueries

Life gets complicated when you make subqueries. Here's how I do it:

```sql
SELECT
  bands.*
FROM
  bands
JOIN (
  SELECT
    albums.*
  FROM
    albums
  GROUP
    album.band_id
  WHERE
    album.type = "POP"
  HAVING
    COUNT(*) > 3
  ) ON bands.id = albums.band_id
WHERE
  band.leader_id IN (
    SELECT
      musicians.*
    FROM
      musicians
    WHERE
      musicians.birth_yr > 1940
  )
```

I put the leading paren on the prior line, indent the query two
spaces, and close with a trailing paren at the start of a new line. I
put the `ON` of a `JOIN` right after the closing paren.

## References

* Based on the style guide [How I Write SQL][how-i-write-sql].

[how-i-write-sql]: http://www.craigkerstiens.com/2012/11/17/how-i-write-sql
