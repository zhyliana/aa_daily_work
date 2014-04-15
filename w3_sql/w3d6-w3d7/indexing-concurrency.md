# Indexing: Uniqueness and race conditions

I want to talk about something a bit advanced. It's good to
understand, but not mission-critical for the small apps you will be
building for a while.

Your Rails application server only processes one web request at a time
(it's *single-threaded*); if requests take a long time to process, or
request volume is high, pages will not be served promptly. The typical
solution is to fire up additional app servers. This is called *scaling
out*, or *horizontal scaling*.

Even when you have multiple app servers, you usually have a single db
server. It can handle many SQL queries simultaneously; the database is
*multi-threaded*. So it is typical to have multiple app servers
talking to one db server.

The concurrent execution of SQL updates can be problematic. An
ActiveRecord uniqueness validation is enforced by performing an SQL
query into the model's table, searching for an existing record with
the same value in that attribute. If no record is found, the app
issues a second SQL query to insert or update the record.

Imagine a potential problem when two Rails application servers try to
insert the same record simultaneously. This can happen if a user
clicks a "submit" button twice quickly.

1. AppServer1 issues a DB query to see if a `Person` with email
   "ned@appacademy.io" exists yet. The result is no.
2. AppServer2 issues a DB query to see if a `Person` with email
   "ned@appacademy.io" exists yet. The result is no.
3. AppServer1 issues a DB query to insert a `Person` with email
   "ned@appacademy.io".
4. AppServer2 issues a DB query to insert a `Person` with email
   "ned@appacademy.io".
5. Damn. There are two records with `ned@appacademy.io` even though
   Rails had a validation to protect against that.

This is called a race condition; we don't want AppServer2 to begin its
check+insertion until AppServer1's check+insertion is
complete. However, we cannot insure this at the application server
level.

One solution is to additionally enforce this requirement at the DB
level through a database constraint. Remember that when creating a SQL
index, you can optionally specify that it enforce a uniqueness
constraint. To have AR create an index enforcing uniqueness, write a
migration like so:

```ruby
def change
  # no two users may share an email address
  add_index :persons, :email_address, :unique => true
end
```

In the above example, Rails will still think everything is fine until
step 4. In step four, Rails will still issue the query to insert the
record with the non-unique email; Rails thinks everything is fine.

The difference with the unique index is that the DB will object to the
INSERT command. The database will enforce the constraint. This failure
will cause an error to be thrown in Rails. Your user may get an ugly
error page. However, at least the database wasn't corrupted. And it
should be exceptional that this kind of problem happens .

Bonus: The index will also speed up the enforcement of uniqueness
checks, because the column will be indexed!
