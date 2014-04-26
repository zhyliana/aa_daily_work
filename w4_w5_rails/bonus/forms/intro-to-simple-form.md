# SimpleForm

We've seen already how to create basic forms. In addition to boring,
typical user input, we've even seen how to set a `belongs_to`
association using `FormBuilder#collection_select`.

In this chapter we learn two more abilities: how to set a `has_many
:through` association through check boxes, and how to generally create
associated objects.

## SimpleForm is simple

The `simple_form` gem removes some of the gruntwork of setting up
forms. It is meant to replace `form_for` like so:

```html+erb
<%= simple_form_for(@user) do |f| %>
  <%= f.input :user_name %>
  <%= f.input :password %>
  <%= f.button :submit %>
<% end %>
```

SimpleForm will try to guess the appropriate input type: for instance,
a `string` column in your model will correspond to a `text` input
tag. You may override this with `:as`:

```html+erb
<%= simple_form_for(@user) do |f| %>
  <%= f.input :user_name %>
  <%= f.input :password %>
  <!-- boolean fields normally rendered as check box -->
  <%= f.input :accepts_onerous_license, :as => :radio_buttons %>
  <%= f.button :submit %>
<% end %>
```

SimpleForm will also guess a label; you can specify it with the
`:label` option.

So far, SimpleForm doesn't do anything for you that you couldn't
easily do already, but it does make things a little nicer. We'll also
see later how it formats your form so that it can be nicely rendered
with Bootstrap.

## SimpleForm and `belongs_to` associations

The power of SimpleForm comes from its handling of collections:

```html+erb
<%= simple_form_for(@user) do |f| %>
  <%= f.input :name %>
  <%= f.input :home_city_id, :collection => City.all, :label_method => :name, :value_method => :id %>

  <%= f.button :submit %>
<% end %>
```

This works much like `FormBuilder#collection_select` to render a
select box. But we get additional power because we may use `:as =>
:radio_buttons` if you prefer them to be rendered that way.

The `:label_method` and `:value_method` options give names of methods
to generate the name in the select box and the value to be posted back
to the server. The defaults are `:name` and `:id` respectively; we've
just made them explicit here.

## SimpleForm and `has_many :through` associations

Imagine the following models: 

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  attr_accessible :name, :visited_city_ids

  belongs_to :home_city

  has_many :city_visits
  has_many :visited_cities, :through => :city_visits, :source => :city
end

# app/models/city_visit.rb
class CityVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
end

# app/models/city.rb
class City < ActiveRecord::Base
  attr_accessible :name
end
```

Say we would like to make a form where, when a user is created, they
list the cities they have visited. More specifically, we want to build
elements of in the join table, `city_visits`.

The first trick to read in the Rails associations guides that, if you
setup a `has_many :through` association, you can create items in the
join table by setting `user.visited_city_ids = [city_id1, city_id2]`:

```
1.9.3p194 :006 > City.create(:name => "Rome")
   (0.1ms)  begin transaction
  SQL (1.4ms)  INSERT INTO "cities" ("created_at", "name", "updated_at") VALUES (?, ?, ?)  [["created_at", Sun, 24 Feb 2013 22:01:26 UTC +00:00], ["name", "Rome"], ["updated_at", Sun, 24 Feb 2013 22:01:26 UTC +00:00]]
   (100.5ms)  commit transaction
 => #<City id: 2, name: "Rome", created_at: "2013-02-24 22:01:26", updated_at: "2013-02-24 22:01:26">
1.9.3p194 :007 > User.create(:name => "Ned Ruggeri")
   (0.1ms)  begin transaction
  SQL (0.5ms)  INSERT INTO "users" ("created_at", "name", "updated_at") VALUES (?, ?, ?)  [["created_at", Sun, 24 Feb 2013 22:01:38 UTC +00:00], ["name", "Ned Ruggeri"], ["updated_at", Sun, 24 Feb 2013 22:01:38 UTC +00:00]]
   (100.6ms)  commit transaction
 => #<User id: 2, name: "Ned Ruggeri", created_at: "2013-02-24 22:01:38", updated_at: "2013-02-24 22:01:38">
1.9.3p194 :008 > ned = User.first
  User Load (0.3ms)  SELECT "users".* FROM "users" LIMIT 1
 => #<User id: 2, name: "Ned Ruggeri", created_at: "2013-02-24 22:01:38", updated_at: "2013-02-24 22:01:38">
1.9.3p194 :009 > ned.visited_city_ids
   (0.2ms)  SELECT "cities".id FROM "cities" INNER JOIN "city_visits" ON "cities"."id" = "city_visits"."city_id" WHERE "city_visits"."user_id" = 2
 => []
1.9.3p194 :011 > ned.visited_city_ids = [City.first.id]
  City Load (0.2ms)  SELECT "cities".* FROM "cities" LIMIT 1
  City Load (0.1ms)  SELECT "cities".* FROM "cities" WHERE "cities"."id" = ? LIMIT 1  [["id", 2]]
  City Load (0.1ms)  SELECT "cities".* FROM "cities" INNER JOIN "city_visits" ON "cities"."id" = "city_visits"."city_id" WHERE "city_visits"."user_id" = 2
   (0.1ms)  begin transaction
  SQL (0.5ms)  INSERT INTO "city_visits" ("city_id", "created_at", "updated_at", "user_id") VALUES (?, ?, ?, ?)  [["city_id", 2], ["created_at", Sun, 24 Feb 2013 22:02:07 UTC +00:00], ["updated_at", Sun, 24 Feb 2013 22:02:07 UTC +00:00], ["user_id", 2]]
   (0.5ms)  commit transaction
 => [2]
```

Notice especially how this inserted rows into `city_visits`. All we
need to do is (1) set `visited_city_ids` as attr_accessible and (2)
find a way for the form to upload an attribute value for
`params[:user][:visited_city_ids]`. Then, when the controller calls
`User.create(params[:user])`, it wil set `visited_city_ids`.

SimpleForm makes this, ehm, simple.

```html+erb
<%= simple_form_for(@user) do |f| %>
  <%= f.input :name %>
  <%= f.input :visited_city_ids,
              :collection => City.all,
              :label_method => :name,
              :value_method => :id,
              :as => :check_boxes %>

  <%= f.button :submit %>
<% end %>
```

This will create a series of check boxes; each box you tick will be
another entry in an uploaded array of selections. (The default is a
"multi-select box", which is kind of ugly).

This would have been a PITA to do with `FormBuilder`, so this is new
power for you.

## Validating associated objects

### The problem

Let's tighten up our `CityVisit` model:

```ruby
class CityVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :city

  validates :user_id, :presence => true
  validates :city_id, :presence => true
end
```

We are cryptically informed: `Validation failed: City visits is
invalid`. Let's drop a debugger breakpoint in
`UsersController#create` to see what's wrong:

```
[10, 19] in /Users/ruggeri/aa/demos/rails/VisitedCities/app/controllers/users_controller.rb
   10      begin
   11        @user.save!
   12        redirect_to user_url(@user)
   13      rescue
   14        debugger
=> 15        raise
   16      end
   17    end
   18
   19    def show
/Users/ruggeri/aa/demos/rails/VisitedCities/app/controllers/users_controller.rb:15
raise
(rdb:8) p @user.errors
#<ActiveModel::Errors:0x007fa020927530 @base=#<User id: nil, name: "asfasdf", created_at: nil, updated_at: nil, home_city_id: 5>, @messages={:city_visits=>["is invalid"]}>
(rdb:8) p @user.city_visits.first.errors
#<ActiveModel::Errors:0x007fa0223a4c28 @base=#<CityVisit id: nil, user_id: nil, city_id: 5, created_at: nil, updated_at: nil>, @messages={:user_id=>["can't be blank"]}>
```

Did you know we could do that? Just start your rails server with
`rails server --debugger`.

The problem here is that the `user_id` column is not being set. That's
because ActiveRecord first validates the `User` and `CityVisit` before
saving either. At that time, neither of them have an `id`, because
neither has been inserted into the database.

The first step of the solution is to modify the validations slightly:

```ruby
class CityVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :city

  validates :user, :presence => true
  validates :city, :presence => true
end
```

This tells the `CityVisit` to validate that it has an associated
`user` and `city`. This is different than `user_id` and `city_id`,
because even if the associated object merely exists *in memory*, and
is not yet saved to the DB, the association will still pass.

This still won't work yet. That's because the `CityVisit` doesn't
understand that even though it is created by `User#visited_city_ids=`,
it belongs to that `User`.

### In-memory associations

ActiveRecord can be made to understand that two associated objects are
linked even if neither has been saved (this is called an *in-memory*
link). Certainly:

```ruby
1.9.3p194 :001 > u = User.new
 => #<User id: nil, name: nil, created_at: nil, updated_at: nil, home_city_id: nil>
1.9.3p194 :002 > cv1 = u.city_visits.build
 => #<CityVisit id: nil, user_id: nil, city_id: nil, created_at: nil, updated_at: nil>
1.9.3p194 :004 > u.city_visits
 => [#<CityVisit id: nil, user_id: nil, city_id: nil, created_at: nil, updated_at: nil>]
```

See! When we write `u.city_visits.build`, ActiveRecord builds an
associated `CityVisit` object, **and** when we later write
`u.city_visits` again, it remembers the unsaved `CityVisit`. That's an
in-memory association.

One thing we don't get for free:

```ruby
1.9.3p194 :003 > cv1.user
 => nil
```

Huh? If the `User` can remember the in-memory `CityVisit`, why doesn't
the `CityVisit` remember the `User`? The problem is that when we call
`u.city_visits.build`, the special array returned by
`User#city_visits` doesn't understand that `CityVisit` has an
"inverse" association (named `user`) that is supposed to point back to
`User`.

To fix this problem, we specify an inverse on the has_many association:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :city_visits, :inverse_of => :user
  has_many :visited_cities, :through => :city_visits, :source => :city
end

# app/models/city_visits.rb
class CityVisit < ActiveRecord::Base
  belongs_to :user, :inverse_of => :city_visits
  belongs_to :city, :inverse_of => :city_visits

  validates :user, :presence => true
  validates :city, :presence => true
end
```

We've added an `:inverse_of` option to all our `belongs_to` and
`has_many`; this is the best practice. Whenever we write
`user.city_visits.build`, this will setup the in-memory association
both from `user` to the new `CityVisit`, but also back again.

See http://stackoverflow.com/a/4783112

## `SimpleForm::FormBuilder#association`

For convenience, simple form offers a method that takes care of
associations for us:

```html+erb
<%= simple_form_for(@user) do |f| %>
  <%= f.association :home_city %> <!-- generates select box -->
  <%= f.association :visited_cities, :as => :check_boxes %> <!-- generates check boxes -->
  
  <%= f.button :submit %>
<% end %>
```

These helpers just convert into the lower-level versions we have
already seen.

## References

* https://github.com/plataformatec/simple_form/wiki/Nested-Models
