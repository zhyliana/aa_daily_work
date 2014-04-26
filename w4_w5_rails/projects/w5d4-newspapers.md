# Newspaper

In this project, we build a newspaper subscription service.

## Phase I: `Newspaper`

Write a `Newspaper` model. It should have a title and editor. Write a
form to fill in these details.

## Phase II: `SubscriptionPlan`

Write a `SubscriptionPlan` model. It should have a price and a boolean
to indicate weekly or daily. Write a form at
`/newspapers/:newspaper_id/subscription_plans/new` to build a new
subscription plan.

Note: validating presence of a boolean requires a specific validation:
` validates_inclusion_of :field_name, :in => [true, false] `
See more at: http://stackoverflow.com/questions/4112858/radio-buttons-for-boolean-field-how-to-do-a-false

On the `Newspaper` show page, list the available `SubscriptionPlan`s.

## Phase III: Nested `SubscriptionPlan`

Allow creation of a few `SubscriptionPlan`s at the same time that you
build the `Newspaper`. Use a nested form for this.

**Make sure to have a validation on `SubscriptionPlan` which checks
that it has an associated `Newspaper`.**

## Phase IV: `User` and `Subscription`

Write a `User` model; it should contain a name. On signup, the `User`
should be able to select from many `SubscriptionPlan`s (use
checkboxes). Create `Subscription` records, which join `User` and
`SubscriptionPlan`.

## Phase V: `User` and `Subscription`

Instead of a mess of checkboxes to select subscriptions, make a series
of drop-downs, each of which allows you to select one subscription for
each `Newspaper`.

This is advantageous, because you really can only have (at most) one
subscription to any one newspaper.

**Hints:** Loop through the `Newspapers`, hand write the select input tag 
for each, and then loop through the associated `SubscriptionPlan`s for
each, creating an `option` for each plan. What would a good name for 
the select input tags be (hint: each one uploads one `subscription_id`).
