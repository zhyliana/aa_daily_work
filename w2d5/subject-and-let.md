# `subject` and `let`

## `subject`

To test a class, you will often want to instantiate an instance of the
object to test it out. In this case, you may want to define a `subject`
for your tests.

```ruby
describe Robot do
  subject(:robot) { Robot.new }
  its(:position) { should eq [0, 0] }

  describe "move methods" do
    it "moves left" do
      robot.move_left
      robot.position.should eq([-1, 0])
    end
  end
end
```

The `subject` method is passed a name for the subject (`:robot`), as
well as a block which constructs the subject. You can do any necessary
setup inside the block.

The `#position` test uses `its`, which takes a method and
runs it on the `subject`, saying the returned value should be
`[0, 0]`. For attributes and simple methods, this `its` syntax can be
much cleaner and is preferred.

*NB: `its` operates exclusively on `subject`*

Other tests need to do more than test the initial value. For instance,
the second test first moves the robot, then tests its
position. You can't use the `its` method for this, but we can refer to
the robot explicitly through the name we gave it.

**Note that `subject` is defined outside of an `it` spec**. Neither
`subject` nor `let` can be defined inside of a spec; they are defined
outside specs and used within them.

*Use `subject` and `its` where possible.*

## `let`

`subject` lets us define the subject of our tests. Sometimes we also
want to create other objects to interact with the subject. To do this,
we use `let`. `let` works just like `subject`, but whereas `subject`
is the focus of the test, `let` defines helper objects. Also, there
can only be one `subject` (if you call it again, the subject is
overriden), whereas you can define many helper objects through `let`.

```ruby
describe Robot do
  subject(:robot) { Robot.new }
  let(:light_item) { double("light_item", :weight => 1) }
  let(:max_weight_item) { double("max_weight_item", :weight => 250) }

  describe "#pick_up" do
    it "should not add item past maximum weight of 250" do
      robot.pick_up(max_weight_item)

      expect do
        robot.pick_up(light_item)
      end.to raise_error(ArgumentError)
    end
  end
end
```

`let` defines a method (e.g. `light_item`, `max_weight_item`) that runs
the block provided once for each spec in which it is called.

You may see that you have the option of using instance variables in a
`before` block to declare objects accessible to specs, but we'll
avoid defining instance variables in specs. Always prefer `let`.
Here's a [SO post][stack-overflow-let] that clearly describes why
that is.

Here's a [blog post][dry-up-rspec] with some nice examples using `let` -
note how the author uses it in conjunction with `subject` (some fancy
and clean stuff).

[stack-overflow-let]: http://stackoverflow.com/questions/5359558/when-to-use-rspec-let
[dry-up-rspec]:http://benscheirman.com/2011/05/dry-up-your-rspec-files-with-subject-let-blocks/

### `let` does not persist state

You might read that `let` memoizes its return value. Memoization means
that the first time the method is invoked, the return value is cached
and that same value is returned every subsequent time the method is
invoked within the same scope. Since every `it` or `its` block is a
different scope, `let` does not persist state between those specs.

An example:

```ruby
class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

describe "let" do
  let(:cat) { Cat.new("Sennacy") }

  it "returns something we can manipulate" do
    cat.name = "Rocky"
    cat.name.should == "Rocky"
  end

  it "does not persist state" do
    cat.name.should == "Sennacy"
  end
end

# => All specs pass
```
