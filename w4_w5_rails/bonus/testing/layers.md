# The layers of Rails testing

There are many layers of Rails testing. Here they are:

* Model layer (`spec/models`): your models, the most specific,
  detailed tests go here.
* Routing layer (`spec/routing`): tests that urls are dispatched to
  the right controller/action. These are seldom tested.
* Controller layer (`spec/controllers`): controllers, these test that
  the controller makes the right updates to the db (perhaps it creates
  a new item on a POST request), sets the right instance variables
  that a view will need, and renders the right template. Controller
  tests are one of the less important ones; they are normally caught
  in integration tests (hold on!).
* View layer (`spec/views`): your views, that they contain the right
  information. These tests are normally fairly primitive (does the
  rendered page have the right title?), but are typically easy to
  write.
    * View helpers (`spec/helpers`): view helpers should be
      tested. Because they are small bits of code packaged in methods,
      they are usually easy to test.
* Integration tests (`spec/requests`): end-to-end tests of your site's
  functionality. Leverages the capybara gem to simulate a user's
  interaction with the site.

**If you only test two things**: test models and integration tests.

## Model layer

Model specs (often called *unit tests*, since they test each model as
an independent unit) are the least Railsy of the tests we write. You
should write your tests as if this wasn't even a Rails application.

Model specs go in `spec/models/`; they'll be generated for you if you
`rails g model ...`.

```ruby
# spec/models/secret_spec.rb
require 'spec_helper'

describe Secret do
  subject (:secret) do
    Secret.new(
      :screen_name => "screen_name",
      :body => "body"
    )
  end

  it "is not valid without a screen name" do
    subject.screen_name = nil
    subject.should_not be_valid
  end

  it "is not valid without a body" do
    subject.body = nil
    subject.should_not be_valid
  end

  it "is valid with screen name and body" do
    subject.should be_valid
  end
end
```

Notice that we've included `spec_helper` at the top; every spec file
should include this; you'll put shared helper code in here.

**TODO**: describe FactoryGirl

Don't forget to migrate the database if you have new models:

```
~/TempProject$ rake db:test:prepare
You have 1 pending migrations:
  20130204182856 CreateSecrets
Run `rake db:migrate` to update your database then try again.
~/TempProject$ rake db:migrate
==  CreateSecrets: migrating ==================================================
-- create_table(:secrets)
   -> 0.0065s
==  CreateSecrets: migrated (0.0065s) =========================================

~/TempProject$ rake db:test:prepare
```

## Controller layer

Controller tests are sometimes also called *functional
tests*. Controller tests are kicked off by making a request to the
controller (`get`, `post`, etc). Things to test are the assigned
instance variables, that the correct template is rendered, or the
correct redirect issued. You can also check that the flash or session
is set properly. Especially in the case of forms, you may wish to test
that the database inserts an element correctly.

A lot of functionality tested in the controller is duplicated in tests
at the integration level, so not a huge level of effort is expended at
this level.

```ruby
# spec/controllers/secrets_controller_spec.rb
describe SecretsController do
  describe "#show" do
    let(:secret) { double("secret") }

    before do
      Secret.stub(:find).with("1234").and_return(secret)
      get :show, { :id => 1234 }
    end

    it "assigns the requested secret" do
      # can also check `flash` and `session`
      assigns(:secret).should == secret
    end

    it "renders the show template" do
      # this is the kind of test I wouldn't bother with
      expect(response).to render_template("show")
    end
  end

  describe "#create" do
    let(:secret_params) do
      { :secret => {
          :screen_name => "screen_name", :body => "body"
        }
      }
    end

    it "creates the secret" do
      expect do
        post :create, secret_params
      end.to change{Secret.count}.by(1)
    end

    it "redirects after successful create" do
      post :create, secret_params
      expect(response).to redirect_to(secret_url(assigns(:secret).id))
    end
  end
end
```

**TODO**: wants the routing? and the view?

## View layer

```ruby
# spec/views/secrets/show_spec.rb
require 'spec_helper'

describe "secrets/show" do
  let(:secret) do
    double("secret", :screen_name => "my_screen_name", :body => "my_body_text")
  end

  before do
    assign(:secret, secret)
    render
  end

  it "should display screen_name" do
    expect(rendered).to include(secret.screen_name)
  end

  it "should display body" do
    expect(rendered).to include(secret.body)
  end

  it "should link back to index" do
    expect(rendered).to include(link_to("Back", secrets_url))
  end
end
```

**TODO**: `assert_select`, `css_select`, two-arg `css_select` version
inside an element?

## Request specs

See the [request specs][request-specs] chapter.

[request-specs]: request-specs.md

## References

**TODO**: more about these links

* https://github.com/rspec/rspec-rails
* https://github.com/thoughtbot/shoulda-matchers
* https://github.com/bmabey/email-spec
