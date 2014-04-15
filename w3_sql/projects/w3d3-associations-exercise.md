# Associations Exercise

**Start by downloading [this rails project][assoc-exercise] (click Download Zip in the github sidebar).**
**Unzip the file and run `bundle install` to ensure that you have
all necessary gems.**
[assoc-exercise]: https://github.com/appacademy-demos/AssociationsExercise

We are going to write active record associations to connect some models. 
A rails project has been created for your testing purposes with the database
already set up for your convenience. In this project there are three models:
`User`, `Course`, and `Enrollment`. It is your duty to connect them using
active record associations. 

Be sure and check out the `db/schema.rb` to see what you are dealing with.

## `Enrollment`.

Open the model, `app/models/enrollment.rb`. Add the associations inside the
currently empty class. You will need associations for `User` and `Course`.

After you are done adding the associations, the following should work in 
the `rails console`.

`Enrollment.first.user`
and
`Enrollment.first.course`

these commands should return the associated user and course for the first
enrollment.

## `User` 

Add associations for `enrollments` and 
`enrolled_courses`. This might take a little bit of thinking.

You will know you have succeeded when you can do the following in the 
`rails console`. 

`User.first.enrollments` and
`User.first.enrolled_courses`

These commands should return the user's enrollments and enrolled courses.


## `Course`

Add `enrollments` and `enrolled_students`
associations.

You can infer how to test these based on our previous work.

Now, let's really get tricky. Head back to `Course` and add an association
for `prerequisite`. This should return a course's prereq (if it has one). 

Finally, let's add an `instructor` association to `Course`. 

Now, call your TA over and demonstrate all of these associations in the 
`rails console`.
