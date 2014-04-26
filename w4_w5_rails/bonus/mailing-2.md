# Bonus mailing topics

## Receiving Emails

Receiving and parsing emails with Action Mailer can be a rather
complex endeavor. Before your email reaches your Rails app, you would
have had to configure your system to somehow forward emails to your
app, which needs to be listening for that. So, to receive emails in
your Rails app you'll need to:

* Implement a `receive` method in your mailer.

* Configure your email server to forward emails from the address(es)
you would like your app to receive to `/path/to/app/script/rails
runner 'UserMailer.receive(STDIN.read)'`.

Once a method called `receive` is defined in any mailer, Action Mailer
will parse the raw incoming email into an email object, decode it,
instantiate a new mailer, and pass the email object to the mailer
`receive` instance method. Here's an example:

```ruby
class UserMailer < ActionMailer::Base
def receive(email)
page = Page.find_by_address(email.to.first)
page.emails.create(
subject: email.subject,
body: email.body
)

if email.has_attachments?
email.attachments.each do |attachment|
page.attachments.create({
file: attachment,
description: email.subject
})
end
end
end
end
```

## Asynchronous

Rails provides a Synchronous Queue by default. If you want to use an
Asynchronous one you will need to configure an async Queue provider
like Resque. Queue providers are supposed to have a Railtie where they
configure it's own async queue.

### Custom Queues

If you need a different queue than `Rails.queue` for your mailer you
can use `ActionMailer::Base.queue=`:

```ruby
class WelcomeMailer < ActionMailer::Base
  self.queue = MyQueue.new
end
```

or adding to your `config/environments/$RAILS_ENV.rb`:

```ruby
config.action_mailer.queue = MyQueue.new
```

Your custom queue should expect a job that responds to `#run`.
