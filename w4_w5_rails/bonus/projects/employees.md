# Employee database

## Models

Name all these associations as I say: you need to practice
`class_name`, `foreign_key`, etc.

* `Employee` model
    * Set up `supervisor`/`subordinates` associations
    * Should use a `supervisor_id` attribute
* `Team`
    * Join with `Employee` using `TeamMembership` model
        * Attributes should be `employee_id`, `team_id`
        * Associations should be `employee`, `team`
    * Add a `Team#memberships` association to pull the `Team`'s
      `TeamMembership`s.
    * Add a `Employee#team_memberships` association to pull the
      `Employee`'s `TeamMembership`s.
    * Add `Employee#teams` and `Team#members` associations
* `Team` should have a `Team#supervisor` association
    * Use a FK column in `Team` named `supervisor_id`
    * Add an inverse association `Employee#supervised_teams`
* Add an `EmployeeProfile` model
    * `Employee` and `EmployeeProfile` have one-to-one relation.
    * Include several preferences and pieces of information for the employee; you can add whatever
      you want, but here are ones you should have:
         * Height
         * Age
         * Favorite food
         * Favorite day of the week (should be constrained to the actual days of the week)
         * Date of birth (use a date select)
         * Salary
         * Photo (try to see if you can have a user upload a photo of their choosing or enter
           a url to a photo)

## Forms

Write a web-interface to create/edit each of these models.

You should have forms for `Employee`/`EmployeeProfile` and `Team`. You should be able to select an `Employee`'s `Team`
on creation, and also select `Employee`s when creating a `Team`. On edit, for both models, be able to check/uncheck
these relationships.

NB: See [build for has_one][soThread].

[soThread]: http://stackoverflow.com/questions/2472982/using-build-with-a-has-one-association-in-rails
