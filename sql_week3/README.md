# Intro to SQL and ActiveRecord

## w3d1

+ **Assessment02** ([practice][assessment-practice])
    + We'll implement a simple version of
      [Crazy Eights][crazy-eights]. You can lookup the basic rules
      ahead of time.
+ SQL Fundamentals (Read them first!)
    + [SQL For The Impatient][sql-intro]
    + [A Visual Explanation of Joins][visual-joins]
    + [Formatting SQL Code][sql-formatting]
+ [Learning SQL: Setup][learning-sql-setup]
+ [Learning SQL: Part I][learning-sql-part-i]
+ **Project**: [SQL Zoo][sql-zoo]
    * Make sure to use the **MySQL DB option**. Because of bugs on the
      SQL Zoo site, results will be screwy if you select one of the
      other databases.
    * Do the tutorials; you can skip the quizes if you like.
    * Careful! SQL Zoo will truncate the results if there are too
      many; take results of test queries with a grain of salt.

[assessment-practice]: http://github.com/appacademy/assessment-prep
[crazy-eights]: http://en.wikipedia.org/wiki/Crazy_Eights

[sql-intro]: ./w3d1/sql-intro.md
[visual-joins]: http://www.codinghorror.com/blog/2007/10/a-visual-explanation-of-sql-joins.html
[sql-formatting]: ./w3d1/formatting.md

[learning-sql-setup]: ./w3d1/setup.md
[learning-sql-part-i]: ./w3d1/part-i.md
[sql-zoo]: http://sqlzoo.net/

## w3d2

+ [Learning SQL: Part II][learning-sql-part-ii]
+ [SQLite3][sqlite3]
+ [Heredocs][heredocs]
+ **Demo Readings**: [SQLite3 demo][sqlite3-demo]
    + Make sure to read this before class! It is essential!
+ **Project**: [AA Questions][aa-questions]

[learning-sql-part-ii]: ./w3d2/part-ii.md
[sqlite3]: ./w3d2/sqlite3.md
[heredocs]: ./w3d2/heredocs.md

[patients-demo]: ./w3d2/demos/patients-demo
[sqlite3-demo]: ./w3d2/demos/sqlite3-demo

[aa-questions]: ./projects/w3d2-aa-questions.md

## w3d3

* **Assessment02 Retake**
* [Your first Rails project][first-rails-project]
+ [Migrations][ar-migrations]
+ [What is an ORM?][ar-orm]
+ Associations
    + [`belongs_to` and `has_many`][belongs-to-has-many]
        * Learn this well; specify
          `class_name`/`primary_key`/`foreign_key` on all associations
          until I give you leave to let Rails infer these.
    + [`has_many :through`][has-many-through]
    + [`has_one`][has-one]
    + [Rails Conventions][rails-conventions]
    + [Unconventional Associations][unconventional-associations]
+ Validations
    + This stuff is less important than mastering associations and can
      be read during class the next day if necessary.
    + [Basics][validations]
    + [Custom Validations][custom-validations]
    + [Miscellaneous][validations-misc]
+ [ActiveRecord and Indexes][ar-indexing]
    + This is also less vital and can be read the day of the project.
+ **Exercise**: [Associations Exercise][associations-exercise]
+ **Project**: [URL Shortener][url-shortener]

[first-rails-project]: ./w3d3/first-rails-project.md
[ar-migrations]: ./w3d3/migrations.md
[ar-orm]: ./w3d3/orm.md

[belongs-to-has-many]: ./w3d3/belongs-to-has-many.md
[has-many-through]: ./w3d3/has-many-through.md
[has-one]: ./w3d3/has-one.md
[rails-conventions]: ./w3d3/rails-conventions.md
[unconventional-associations]: ./w3d3/unconventional-associations.md

[validations]: ./w3d3/validations/validations.md
[custom-validations]: ./w3d3/validations/custom-validations.md
[validations-misc]: ./w3d3/validations/validations-misc.md

[ar-indexing]: ./w3d3/indexing.md

[associations-exercise]: ./projects/w3d3-associations-exercise.md
[url-shortener]: ./projects/w3d3-url-shortener.md

## w3d4

+ [ActiveRecord::Relation][relation]
+ [ActiveRecord and Joins][ar-joins]
+ [Scopes][scopes]
+ [More on Querying][querying-ii]
+ **Demo**: [JoinsDemo][joins-demo]
+ **Project**: [Polls][polls-project]

[relation]: ./w3d4/relation.md
[ar-joins]: ./w3d4/joins.md
[scopes]: ./w3d4/scopes.md
[querying-ii]: ./w3d4/querying-ii.md

[joins-demo]: https://github.com/appacademy-demos/JoinsDemo

[polls-project]: ./projects/w3d4-polls.md

## w3d5

+ [Metaprogramming][metaprogramming]
+ [Class Instance Variables][class-instance-variables]
+ [Reading Demo: send][meta-send]
+ [Reading Demo: macros][meta-macros]
+ **Solo Project**: [Build Your Own ActiveRecord][build-your-own-ar]

[metaprogramming]: ./w3d5/metaprogramming.md
[class-instance-variables]: ./w3d5/class-instance-variables.md
[meta-send]: ./w3d5/send.rb
[meta-macros]: ./w3d5/macros.rb
[build-your-own-ar]: ./projects/w3d5-build-your-own-ar.md

## Bonus

+ [Callbacks][callbacks]
+ [Delegation][delegation]

[callbacks]: ./w3d6-w3d7/callbacks.md
[delegation]: ./bonus/delegation.md
