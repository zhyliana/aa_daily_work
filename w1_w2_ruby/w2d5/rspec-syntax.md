# RSpec Syntax & Mechanics

RSpec is distributed in a gem called 'rspec', which is actually a
meta-gem that packages three other gems: rspec-core, rspec-expectations,
and rspec-mocks. We'll spend most of our time on rspec-core and  rspec-
expectations.

Some of the syntax and framing will be covered here, but the READMEs
of both rspec-core and rspec-expectations are required reading.

* [rspec-core][rspec-core]
* [rspec-expectations][rspec-expectations]

## File Organization

By convention, tests are kept in the `spec` folder and your application
code will be kept in a `lib` folder. Tests for `hello.rb` will be
written in a file called `hello_spec.rb`.  Pro tip: cd to the project folder and run
`rspec --init` to set up some of the structure. 

```
lib/
  hello.rb
spec/
  hello_spec.rb
Rakefile
```
## Requiring Dependencies

Each spec will usually be limited to testing a single file and so
will require the file at the top of the spec. It will also have to
require the rspec gem.

*hello_spec.rb*

```
require 'rspec'
require './hello'

describe '#hello_world' do

end
```

Note that RSpec will by default include the `lib/` folder in the
require path so that we can use `require` and not `require_relative`.
This is another reason to follow the convention of using `lib/` and
`spec/` for your code and your tests, respectively.

## Organization & Syntax

Here's what a simple 'Hello, World!' spec might look like.

*hello_spec.rb*

```
require 'rspec'
require 'hello'

describe "#hello_world" do
  it "returns 'Hello, World!'" do
    expect(hello_world).to eq("Hello, World!")
  end
end
```

And the code that would make it pass:

*hello.rb*

```
def hello_world
  "Hello, World!"
end
```

### `describe` & `it`
---

`it` is RSpec's most basic test unit. All of your actual individual
tests will go inside of an `it` block.

`describe` is RSpec's unit of organization. It gathers together
several `it` blocks into a single unit, and, as we'll see, allows you
to set up some context for blocks of tests.

Both `describe` and `it` take strings as arguments. For `describe`,
use the name of the method you're testing (use "#method" for instance
methods, and "::method" for class methods). For `it`, you should
describe the behavior that you're testing inside that `it` block.

`describe` can also take a constant that should be the name of the
class or module you're testing (i.e. `describe Student do`).

You can nest `describe` blocks arbitrarily deep. When nesting, also
consider the use of `context`, which is an alias for `describe` that
can be a bit more descriptive. Prefer `context` when it makes sense.

```
describe Student do
  context 'when a current student' do
    ...
  end

  context 'when graduated' do
    ...
  end
end
```

### `expect`
---

`describe` and `it` organize your tests and give them descriptive
labels. `expect` will actually be doing the work of testing your
code.

Its task is to *match* between a value your code generates and an
expected value. You can specify the way in which it will match.

There are negative and positive constructions:

```
expect(test_value).to ...
expect(test_value).to_not ...
```

There are two constructions to expect: with an argument and with a
block. We'll prefer the argument construction except when the block
construction is necessary.

```
describe Integer do
  describe '#to_s' do
    it 'returns string representations of integers' do
      expect(5.to_s).to eq('5')
    end
  end
end
```

The block construction is necessary when you want to test that a
certain method call will throw an error:

```
describe '#sqrt' do
  it 'throws an error if given a negative number' do
    expect { sqrt(-3) }.to raise_error(ArgumentError)
  end
end
```

RSpec comes with a variety of matchers that come after `expect().to`
or `expect().to_not`. The most common and staightforward matchers are
straight equality matchers.

`expect(test_value).to eq(expected_value)` will see if `test_value ==
expected_value`. `expect(test_value).to be(expected_value)` will test if
`test_value` is the same object as `expected_value`.

```
expect('hello').to eq('hello') # => passes ('hello' == 'hello')
expect('hello').to be('hello') # => fails (strings are different objects)
```

---

At this point, you know the absolute basics of RSpec's syntax. Head on
over to the GitHub pages and read both of the READMEs. Pay  particular
attention to the variety of expectation matchers available to you.

* [rspec-core][rspec-core]
* [rspec-expectations][rspec-expectations]

Head back here once you're done.

### `before`
---

Welcome back! Hope you've learned a lot more about what RSpec allows
you to do.

One thing that we often want to do is set up the context in which our
specs will run. We usually do this in a `before` block.

```
describe Chess do
  let(:board) { Board.new }

  describe '#checkmate?' do
    context 'when in checkmate' do
      before(:each) do
        board.make_move([3, 4], [2, 3])
        board.make_move([1, 2], [4, 5])
        board.make_move([5, 3], [5, 1])
        board.make_move([6, 3], [2, 4])
      end

      it 'should return true' do
        expect(board.checkmate?(:black)).to be_true
      end
    end
  end
end
```

`before` can be used as either `before(:each)` or `before(:all)`.
You'll almost always use `before(:each)`. `before(:each)` will execute
the block of code before each spec in that `describe` block. The nice
thing about it is that state is not shared - that is, you start fresh
on every spec, even if inside your spec (i.e. in your `it` block) you
manipulate some object that the `before` block set up for you.

`before(:all)` on the other hand does share state across specs and
for that reason, we avoid using it. It makes our tests a bit brittle by
making specs dependent on one another (and dependent on the order in
which specs are run).

There are also `after(:each)` and `after(:all)` counterparts.

### Pending Specs
---

Sometimes, you may want to write out a bunch of descriptions for specs
without actually writing the bodies of those specs. If you simply
leave the test bodies empty, it'll look like they're all passing. If
you fail them, then it'll look like you actually have test code
written that is currently failing.

What to do? Make the specs pending.

How?

Leave off the `do...end` from the `it`.

```
describe '#valid_move?' do
  it 'should return false for wrong colored pieces'
  it 'should return false for moves that are off the board'
  it 'should return false for moves that put you in check'
end
```

## Rake

Rake is a Ruby task runner. You can define tasks written in Ruby, and
Rake will run them for you when you tell it to.

Rake will look for a `Rakefile` in the directory in which it is called
and run the specified task (i.e. `rake spec` will run the 'spec' task
as it is defined in the Rakefile). If no argument is specified, `rake`
will run whichever task has been specified as the default task.

Let's take a look at a Rakefile we can use for testing:

*Rakefile*

```
require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = false
  t.rspec_opts = ["--format documentation", "--color", "--order=default"]
  t.pattern = ARGV[1] || "spec/*_spec.rb"
end

task :default => :spec

```

Here, RSpec actually provides us with a way to construct Rake tasks
through `RSpec::Core::RakeTask.new`. We pass it a symbol that
corresponds to what we want to call the task, and it yields to us a
configuration object `t` upon which we can set particular options.

In this case, we're removing the stack trace (`t.fail_on_error =
false`), setting some formatting options, and specifying the pattern of
the files it should run (`"spec/*_spec.rb"`), which is all the files in
the `spec/` folder that end in `_spec.rb`. The `ARGV[1]` makes it so
that we could specify a particular file in the command line if we wanted
to.

Finally, we specify that the `:default` task is the `:spec` task, so
now we can run `rake` without any arguments and it will run our specs
for us. We could of course still call `rake spec`.

## Additional Notes

Don't use `!=`.  Rspec does not support `actual.should != expected`.
Instead use `actual.should_not eq expected` or `expect(actual).to_not eq
expected`.

On predicate syntatic sugar: With all predicates, you can strip off the
? and tack on a "be_" to make an expectation.  For example,
`Array.empty?.should == true` is equivalent to `Array.should be_empty`.

Note that RSpec changes the tense of predicate `has_key?`, so your test
should look like `expect(Hash).to have_key :key`.

## Intro Assessment Spec

Go back to the spec from the intro assessment. Read
the spec file and make sure everything makes sense to you.

## Additional Resources

* The [RSpec docs][rspec-docs] are a good resource. Knowing
  RSpec well will let you write beautiful specs. Note that the
  RSpec docs are specs themselves.

[rspec-docs]: https://www.relishapp.com/rspec/rspec-core/v/2-4/docs
[rspec-core]: https://github.com/rspec/rspec-core
[rspec-expectations]: https://github.com/rspec/rspec-expectations
