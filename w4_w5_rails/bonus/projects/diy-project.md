# Choose Your Own Adventure

Today you'll be building a project of your own choosing. This is the time  to
consolidate your knowledge of Rails and ensure you understand how everything
fits together.

Please make sure you pick something that can feasibly be completed in a day
and is within your ability to build. Your TA will come around early in the day
to ensure you're going down a reasonable path.

## Project Requirements

Your project must include the following features, in addition to whatever the
main functionality of your app is:

* At least one set of resourceful routes ought to use custom, non-id url's.
  This won't change anything in `routes.rb`; you'll be overriding the
  `to_param` method on the model. Make sure to make the necessary
  adjustments in your controllers. Look [here][to_param-cdm] or
  [here][to_param-api] for more information.
* You should implement a full password reset feature for your users. That
  is, if a user forgets his password, he should be able to submit his e-mail
  address and receive an e-mail with a link to a password reset page. You'll
  use `ActionMailer` for the reset e-mail; use the
  [`letter_opener`][letter_opener] gem to pop open the e-mail when it's
  sent (or look at the e-mail in the server log).
* The user should be able to upload and download a file - you can make it
  any kind of file you'd like (picture, document, etc.). Feel free to use
  [`paperclip`][paperclip].

[to_param-cdm]: https://gist.github.com/cdmwebs/1209732
[to_param-api]: http://apidock.com/rails/ActiveRecord/Base/to_param
[letter_opener]: https://github.com/ryanb/letter_opener
[paperclip]: https://github.com/thoughtbot/paperclip