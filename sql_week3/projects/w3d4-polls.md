# Polls

In the spirit of enfranchisement, we're going to build a polling app
today!

## Schema

You should write the following models:

* `User`
    * Record a `user_name`; make sure it is unique.
* `Poll`
    * Record a `title` and the poll `author`.
* `Question`
    * A `Poll` consists of many `Question`s. Record the `text`.
* `AnswerChoice`
    * A `Question` consists of many `AnswerChoice`s. Track the `text`.
* `Response`
    * A `User` answers to a `Question`s by choosing an `AnswerChoice`.
    * What pair of foreign keys will you need?

Index all foreign keys appropriately and enforce unqiqueness as appropriate.

## Associations I

* `User`
    * `authored_polls`
    * `responses`
* `Poll`
    * `author`
    * `questions`
* `Question`
    * `answer_choices`
    * `poll`
* `AnswerChoice`
    * `question`
    * `responses`
* `Response`
    * `answer_choice`
    * `respondent`

## Model Level Validations

Add `presence` validations wherever required.

### User can't create multiple responses to the same question

Write a custom validation method,
`respondent_has_not_already_answered_question`, to check that the
`respondent` has not previously answered this question.

The first step is to find all the user's existing responses to this
question. Break down and use `Response::find_by_sql` to do a
relatively sophisticated query across tables. I did this by (a)
writing a subquery that returned the corresponding `question_id` for
the `AnswerChoice` the response referred to. I then (b) joined
`responses` and `answer_choices` tables, selecting only those
responses (b1) the user submitted and (b2) were for the same
`question_id`.

I put this in a private method `Response#existing_responses`.

You may think that it would be sufficient to merely validate that `existing_responses` is
`empty?`. If we were only creating a new response, that would be true. However, we must also cover the case
in which we are changing our answer. If we update a record, the value in one or more of the columns change, but
the object's `id` doesn't change.

If we are updating, when we look through the `existing_responses` we will find a record, _this_ one, the
one with the `id` matching `this.id`.

So, for this record to be valid, one of the following must be true:

0. The `existing_responses` array is empty. (we are saving for the first time)
0. The `existing_responses` array contains _exactly one_ record and its `id` is `self.id`

### Author can't respond to own poll

Enforce that the creator of the poll must not answer their own
questions: don't let the creator rig the results!

To find the poll author, I used AR to do a series of joins, from
`User` through `:polls` through `:questions` through
`:answer_choices`. Look up how to do series of joins if you don't know
how.

I then selected the row with the appropriate `answer_choices.id`.

## Poll results

Write a method `Question#results` that returns a hash of choices and
counts like so:

```ruby
q = Question.first
q.title
# => "Who is your favorite cat?"
q.results
# => { "Earl" => 3, "Breakfast" => 3, "Maru" => 300 }
```

Your challenge is to do this without using an N+1 query. Write a query
which returns `AnswerChoice`s augmented with a count. Don't forget
answers that haven't been selected by anyone (have a response count of
zero)! Finally, convert the array of `AnswerChoice`s to a `Hash`.

## Bonus: more methods

Write the methods `completed_polls` (polls where the user has answered all of the questions in the poll)
and `uncompleted_polls` (polls that the user has started but not completed).

## Technical details

* Allow deletion of questions; clean up all related records with a
  callback.
