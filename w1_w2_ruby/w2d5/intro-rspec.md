# Testing & RSpec

Thus far in our programs, the way we would figure out whether a method
was working in the way we intended it to work was to test it out by hand
in pry or debugger or with a script. This can be tedious, repetitive,
and worst of all, it is a method vulnerable to both false positives and
false negatives. A testing method you can't trust is no testing method
at all.

Enter ***automated testing***.

Programmers realized that this state of testing was a serious problem in
the development of complex applications and various means of  automated
testing were developed to speed and smooth the testing process. The
general idea across all testing frameworks was to allow developers to
write code that would specify the behavior of a method or module or
class. Developers could then simply run the test code against their
application code and have confidence that their code worked as intended.

Joy to the world.

## RSpec

Ruby has a particularly robust testing library in RSpec. RSpec is a
domain-specific language made for testing. It has its own set of
methods, syntax, and patterns that in the end are all Ruby code, but
Ruby code built to support testing.

You've seen what RSpec looks like already because all the specs for
your assessments are written in RSpec.

*NB: RSpec also happens to be the first important Ruby gem we've
encountered. Gems are a Ruby-specific way of packaging and distributing
Ruby libraries. We'll encounter many more gems, especially as we move
into Rails.*

## Why Test?

Yes, making sure the dang thing actually works is important. But beyond
the obvious, why take the time to write tests?

1. To make sure the dang thing works

  Yes, that's obvious, but dagnabit, it's important!

2. Increase flexibility & reduce fear (of code)

  You've written a whole bunch of functionality, multiple other
  developers have worked on the code, you're deep into the project.
  And then you realize you have to refactor big chunks of it. Without
  automated tests, you'll be walking on eggshells, frightened of the
  codebase and the various landmines that are surely laying in wait.

  With tests, you can aggressively refactor with confidence. If
  anything breaks, you'll know. And you'll know exactly what the
  expectations are for the module you're refactoring, so as long as
  it meets the specs, you're good.

3. Make collaboration easier

  Complex applications are built by teams of developers. It may be that
  not all those developers will actually get the chance to talk to one
  another (they're busy, they may live in different places, some of
  them may have left the company, new people just joined, it's a
  huge project, etc.).

  Specs allow teams to have confidence that each module performs a
  specific task and reduces the need for expensive coordination. The
  specs themselves become an effective form of communication.

4. Produce documentation

  If the tests are written well, the tests can serve as documentation
  for the codebase. Need to know what such and such module does?
  Check out the specs. Related to easing collaboration.

Lots more. Trust.

## What to Test

So what exactly should we test?

**Test the public interface.**

When you're trying to figure out what you should be testing, ask
yourself, "What is (or will be) the public interface of the module
or class I'm writing?" That is, what are the methods that the outside
world will have access to and rely on?

Ideally, you'd have thorough test coverage on the entire public
interface. When that's not possible, ensure that your tests cover
the most important and/or complex parts of that interface - that is,
the pieces that you need to make sure work as intended (and
expected).

*What about private methods?*

Sometimes, you'll have some pretty complex private methods and you
might be thinking, "Don't I want to test those?"

The answer is no. Private methods should be supporting public methods,
so if you test those public methods and they work as intended, then
the private methods must be working too. Private methods are part of
the implementation details; when we're testing, what we care about is
behavior.

[Better Specs][better-specs] has lots of good advice for how to write
good tests. You should ignore Rails specific parts (and we'll show you
how to set up guard later), but 90% of the advice should already be
useful. You don't need to read all of this. It's just a good resource
and you should skim through some sections.

[better-specs]: http://betterspecs.org/

## Additional Notes

#### RSpec is a DSL

RSpec is a great example of a [DSL][dsl-wiki], or domain specific
language. A DSL is a language which is dedicated to a particular problem
domain. So, RSpec is a language (or in this case, just a superset of
Ruby) which allows for clearer expression in the testing domain.

[dsl-wiki]: https://en.wikipedia.org/wiki/Domain-specific_language
