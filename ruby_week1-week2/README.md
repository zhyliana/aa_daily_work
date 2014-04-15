# Intro Ruby Topics

## Ruby basics

### w1d1

+ [First Day! **Read me!**][day1-instructions]
+ Primitive Ruby types (common methods)
    + [Array][array]
    + [String][string]
    + [Hash][hash]
    + [Enumerable][enumerable]
    + [Object][object]
+ Debugging
    + [pry and debugger][pry-and-debugger]
    + [common error messages][common-error-messages]
+ Running/loading Ruby code
    + [Source files][source-files]
    + [Writing a Ruby Script][writing-a-script]
+ **Project**: In Words (ex #15) from
  [Test First Ruby][test-first-ruby]
+ **Bonus project**: [Maze solver][maze-project]
+ **Bonus project**: Use Ruby to solve the
  [eight-queens problem][eight-queens].

[day1-instructions]: https://github.com/appacademy/meta/blob/master/first-day-instructions/README.md
[keyboard-shortcuts]: ./w1d1/shortcuts.md
[versions]: ./w1d1/versions.md

[array]: ./w1d1/data-structures/array.md
[string]: ./w1d1/data-structures/string.md
[hash]: ./w1d1/data-structures/hash.md
[enumerable]: ./w1d1/data-structures/enumerable.md
[object]: ./w1d1/data-structures/object.md

[pry-and-debugger]: ./w1d1/debugging/debugger.md
[common-error-messages]: ./w1d1/debugging/common-exceptions.md

[source-files]: ./w1d1/running-ruby-code/source-files.md
[writing-a-script]: ./w1d1/running-ruby-code/writing-a-script.md

[test-first-ruby]: https://github.com/alexch/learn_ruby
[maze-project]: ./projects/w1d1-maze-solver.md
[eight-queens]: http://en.wikipedia.org/wiki/Eight_queens_puzzle

### w1d2

+ [Methods][methods]
+ [Iteration][iteration]
+ [Symbols, Strings, and Option Hashes][symbols-and-strings]
+ [Input/Output][input-output]
+ Style
    + [DRY: Don't Repeat Yourself][dry]
    + [Coding style][coding-style]
    + [Method decomposition][method-decomposition]
    + [Choosing good names][naming]
+ [Classes][classes]
+ [Pass by reference][pass-by-reference]

[methods]: ./w1d2/methods.md
[iteration]: ./w1d2/iteration.md
[symbols-and-strings]: ./w1d2/symbols-and-strings.md
[input-output]: ./w1d2/io.md

[dry]: ./w1d2/style/dry.md
[coding-style]: ./w1d2/style/coding-style.md
[method-decomposition]: ./w1d2/style/method-decomposition.md
[naming]: ./w1d2/style/naming.md

[classes]: ./w1d2/classes.md
[pass-by-reference]: ./w1d2/pass-by-reference.md

## Basic design

### w1d3

+ [Refactoring and Code Smells][code-smells]
+ [Scope][scope]
+ [Hash Defaults][hash-defaults]
+ **Project**: [Mastermind][mastermind]
+ **Project**: [Hangman][hangman]
+ **Bonus project**: [Maze solver][maze-project]
+ **Bonus project**: Use Ruby to solve the
  [eight-queens problem][eight-queens].

[code-smells]: ./w1d3/refactoring.md
[scope]: ./w1d3/scope.md
[hash-defaults]: ./w1d3/hash-defaults.md

[mastermind]: ./projects/w1d3-mastermind.md
[hangman]: ./projects/w1d3-hangman.md

## Algorithms

### w1d4

+ [Blocks][blocks]
+ [Recursion][recursion]
+ **Project**: [Word chains][word-chains]
+ **Bonus Project**: [Test First Ruby][test-first-ruby] XML parser
    * Bonus Reading: [`method_missing`][method-missing]

[blocks]: ./w1d4/blocks.md
[recursion]: ./w1d4/recursion.md

[word-chains]:  ./projects/w1d4-word-chains.md
[test-first-ruby]: https://github.com/alexch/learn_ruby
[method-missing]: ./w1d4/method-missing.md

### w1d5

+ [Intro data structures][intro-data-structures]
+ **Project**: [Knight's Travails][knights-travails]
+ **Project**: [Tic-Tac-Toe AI][tic-tac-toe-ai]

[intro-data-structures]: ./w1d5/intro-algorithms.md

[knights-travails]: ./projects/w1d5-knights-travails.md
[tic-tac-toe-ai]: ./projects/w1d5-tic-tac-toe-ai.md

## Git

### w1d6-w1d7

+ [git][git]
+ [adding with git][git-add]
+ **Project**: [Git immersion][git-immersion]
+ **Project**: Do Hangman and Word chains again, using git this
  time. Do not refer to your old code.
+ [Git Cheatsheet][git-cheatsheet]
+ Make sure to take the [practice assessment][assessment-practice]

[git]: ./w1d6-w1d7/git.md
[git-add]: ./w1d6-w1d7/git-add.md
[git-immersion]: http://gitimmersion.com/
[git-cheatsheet]: http://www.ndpsoftware.com/git-cheatsheet.html

## Language Basics II, OO Design

### w2d1

+ **Assessment01** ([practice][assessment-practice])
    + Please setup Ruby + RSpec on your own machine and bring it.
    + If you need to use one of our machines, please just use a single
      monitor.
+ [Serialization][serialization] (JSON and YAML)
+ [Gems and rvm][gems]
+ **Project**: [Minesweeper][minesweeper]
    * Use git. Here's a [git summary][git-summary].

[assessment-practice]: https://github.com/appacademy/assessment-prep
[serialization]: ./w2d1/serialization.md
[gems]: ./w2d1/gems-and-rvm.md

[minesweeper]: ./projects/w2d1-minesweeper.md
[git-summary]: ./w1d6-w1d7/git-summary.md

### w2d2

+ [Class inheritance][inheritance]
+ [Exceptions, error handling][errors]
+ [Decomposition into objects][object-decomposition]
+ [Inheritance, Polymorphism and DRY][inheritance-design]
+ [Information hiding/encapsulation][hiding]
+ **Project**: [Chess][chess]
    + Please read the project description the night before.

[inheritance]: ./w2d2/inheritance.md
[errors]: ./w2d2/errors.md
[object-decomposition]: ./w2d2/object-decomposition.md
[inheritance-design]: ./w2d2/inheritance-design.md
[hiding]: ./w2d2/hiding.md

[chess]: ./projects/w2d2-chess.md

### w2d3

+ **Assessment01 retake**
+ Continue Chess.

### w2d4

+ As ever, read solutions. But more than usual, read my
  [Chess solution][chess-solution] side-by-side with your own code.
+ **Solo Project**: [Checkers][checkers-project]

[chess-solution]: https://github.com/appacademy/solutions/tree/master/w2/w2d2-w2d3
[checkers-project]: ./projects/w2d4-checkers.md

## RSpec

### w2d5

+ [Introduction to RSpec][intro-rspec]
+ [RSpec Syntax][rspec-syntax]
+ [TDD][intro-tdd]
+ [Test doubles][test-doubles]
+ [`subject` and `let`][subject-and-let]
+ [guard-rspec][guard-rspec]
+ **Demo Reading**: read assessment00 and assessment01 spec files
+ **Demo Reading**: [OO Robot RSpec Example][robot-demo]
+ **Project**: [First TDD Projects][first-tdd-projects]
+ **Project**: [Poker][poker-project]

[intro-rspec]: ./w2d5/intro-rspec.md
[rspec-syntax]: ./w2d5/rspec-syntax.md
[intro-tdd]: ./w2d5/intro-tdd.md
[test-doubles]: ./w2d5/test-doubles.md
[subject-and-let]: ./w2d5/subject-and-let.md
[guard-rspec]: ./w2d5/guard-rspec.md

[robot-demo]: ./w2d5/robot-rspec-demo

[first-tdd-projects]: ./projects/w2d5-first-tdd-projects.md
[poker-project]: ./projects/w2d5-poker.md

### w2d6-w2d7

+ Finish [Poker][poker-project]
+ Begin [SQL Curriculum W3D1][sql-curriculum] readings.

[sql-curriculum]: https://github.com/appacademy/sql-curriculum

## Additional Bonus Topics

+ [Modules][modules]
+ [load/require/require_relative][require]
+ [public/private/protected][privacy]
+ [How RSpec works document][how-rspec-works]
+ [Hash and Equals][hash-and-equals]

[modules]: ./bonus/modules.md
[require]: ./bonus/require.md
[privacy]: ./bonus/privacy.md
[how-rspec-works]: ./bonus/how-rspec-works.md
[hash-and-equals]: ./bonus/hash-and-equals.md
