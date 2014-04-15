# Test Doubles

## A Preface of Great Interest
When we write unit tests, we want each of our specs to test just one
thing. This can be a little complicated when we write classes that
interact with other classes. For example, imagine

```ruby
class Order
  def initialize(customer)
    @customer = customer
  end

  def send_confirmation_email
    email(:to => @customer.email_address, :subject => "Order Confirmation", :body => self.summary)
  end
end
```

Here an `Order` object needs a `Customer` object; the associated
`Customer` object is used, for instance, when we try to call the
`#send_confirmation_email`. In particular, if we want to test
`#send_confirmation_email`, it looks like we'll have to supply `Order`
a `Customer` object.

```ruby
describe Order
  subject(:order) do
    customer = Customer.new(
      :first_name => "Ned",
      :last_name => "Ruggeri",
      :email_address => "ned@appacademy.io"
    )
    Order.new(customer)
  end

  it "should send email successfully" do
    lambda do
      subject.send_confirmation_email
    end.should_not raise_exception
  end
end
```

This is troublesome because a spec for `#send_confirmation_email`
should only test the `#send_confirmation_email` method, not
`Customer#email_address`. But the way we've written this spec, if
there's a problem with `#email_address`, a spec for
`#send_confirmation_email` will also break, even though it should have
nothing to do with `#email_address`. This will clutter up your log of
spec failures.

Another problem is if a `Order` and `Customer` both have methods that
interact with the other. If we write the `Customer` specs and methods
first, then we'll need a functioning `Order` object first for our
`Customer` to interact with. But we're supposed to TDD `Order`; we'll
need to have written specs for `Order`, but this requires a
`Customer`...

Finally, it can be a pain to construct a `Customer` object; we had to
specify a bunch of irrelevant fields here. Other objects can be even
harder to construct, which means we can end up wasting a lot of time
building an actual `Customer`, when an object that merely "looks like"
a `Customer` would have been sufficient.

We want to write our tests in isolation of other classes: their bugs
or whether they've even been implemented yet. The answer to this is to
use *doubles*.

## Test doubles
A test double (also called a *mock*) is a fake object that we can use
to create the desired isolation. A double takes the place of outside,
interacting objects, such as `Customer`. We could write the example
above like so:

```ruby
describe Order
  let(:customer) { double("customer") }
  subject(:order) { Order.new(customer) }

  it "should send email successfully" do
    customer.stub(:email_address).and_return("ned@appacademy.io")

    lambda do
      subject.send_confirmation_email
    end.should_not raise_exception
  end
end
```

We create the double by simply calling the `double` method (we give it
a name for logging purposes). This creates an instance of
`RSpec::Mocks::Mock`. The double is a blank slate, waiting for us to
add behaviors to it.

A method *stub* stands in for a method; `Order` needs `customer`'s
`email_address` method, so we create a stub to provide it. We do this
by passing a symbol with the name of the method that we want to
stub. The `and_return` method takes the return value that the
stubbed method will return when called as its parameter.

The `customer` double simulates the `Customer#email_address` method,
without actually using any of the `Customer` code. This totally
isolates the test from the `Customer` class; we don't use `Customer`
at all. We don't even need to have the `Customer` class defined.

The `customer` object is not a real `Customer`; it's an instance of
`Mock`. But that won't bother the `Order#send_confirmation_email`
method. As long as the object that we pass responds to an
`email_address` message, everything will be fine.

There's also a one-line version of creating a double and specifying
stub methods.

```ruby
let(:customer) { double("customer", :email_address => "ned@appacademy.io") }
```

## Method Expectations
If the tested object is supposed to call methods on other objects as
part of its functionality, we should test that the proper methods are
called. To do this, we use method expectations. Here's an example:

```ruby
describe Order
  let(:customer) { double('customer') }
  let(:product) { double('product', :cost => 5.99) }
  subject(:order) { Order.new(customer, product) }

  it "subtracts item cost from customer account" do
    customer.should_receive(:debit_account).with(5.99)
    order.charge_customer
  end
end
```

Here we want to test that when we call `charge_customer` on an `Order`
object, it tells the `customer` to subtract the item price from the
customer's account. We also specify that we should check that we have
passed `#debit_account` the correct price of the product.

Notice that we set the message expectation before we actually kick off
the `#charge_customer` method. Expectations need to be set up in
advance.

## Integration tests
Mocks let us write unit tests that isolate the functionality of a
single class from other outside classes. This lets us live up to the
philosophy of unit tests: in each spec, test one thing only.

Unit tests specify how an object should interact with other
objects. For instance, our `Order#charge_customer` test made sure that
the order sends a `debit_account` message to its customer.

What if the `Customer` class doesn't have a `#debit_account` method?
Perhaps instead the method is called `Customer#subtract_funds`. Then
in real life, with a real `Customer` object, our
`Order#charge_customer` method will crash when it tries to call
`#debit_account`. What spec is supposed to catch this error?

The problem here is a mismatch in the interface expected by `Customer`
and the interface provided by `Order`. This kind of error won't be
caught by a unit test, because the purpose of unit test is to test
classes in isolation.

We need a higher level of testing that's intended to verify that
`Order` and `Customer` are on the same page: that `Order` tries to
call the right method on `Customer`, which does the thing that `Order`
expects.

This kind of test is called an *integration test*. In integration
tests, we use real objects instead of mocks, so that we can verify
that all the classes interact correctly. A thorough test suite will
have both unit and integration tests. The unit tests are very specific
and are meant to isolate logical problems within a class; the
integration tests are larger in scope and are intended to check that
objects interact properly.

## Resources
* The double facilities are provided in the submodule of RSpec called
  rspec-mocks. You can check out their [github][rspec-mocks-github]
  which has a useful README.

[rspec-mocks-github]: https://github.com/rspec/rspec-mocks
