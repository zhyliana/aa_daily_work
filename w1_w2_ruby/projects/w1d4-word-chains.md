# Word Chains

Read the [Word Chains RubyQuiz][quiz-wayback].

**NB: You shouldn't have to use recursion for this one.**

The general idea is this:

## Phase I: All reachable words

First, write a helper method `adjacent_words(word, dictionary)`. This
should return all words in the dictionary one letter different than
the current word.

Next, let's generate the set of all the words that can be reached
through a chain from a given starting word. Call this
`explore_words(source, dictionary)`. I would follow this general
strategy:

* Initialize a set `words_to_expand` that starts with just the
  source.
* Initialize a set `candidate_words` that includes all the dictionary
  words of the appropriate length.
* Initialize a set `all_reachable_words` that will contain all the
  reachable words. This should in the beginning just contain the
  source.
* Start looping. Each turn, remove a word from `words_to_expand`. Run
  it through `adjacent_words`, using the `candidate_words` as the
  dictionary.
* For each of the adjacent words, remove it from `candidate_words`
  (so that we don't return to it again), and add it to both
  `words_to_expand` and `all_reachable_words`.
* Continue looping until there are no words left to expand.

## Phase II: Finding a chain

Let's copy the code of `explore_words` and rework it into a method
called `find_chain(source, target, dictionary)`.

Do as you did before, but in this case we don't need to keep track of
`all_reachable_words`. Instead, keep a hash called `parents`. Each
time you expand `word1` and encounter a new word `word2`, set
`parents[word2] = word1`. In this way, you keep track of where each
word came from.

Keep looping until you encounter `target`. At this point, information
for getting from `word1` to `word2` exists in the hash.

We need to rebuild the path, it's time to write another method
`build_path_from_breadcrumbs`.

## Phase III: Backtracking

Let's work backward from `target`, going through the steps we took to
get there. Lookup the parent of `target`: this is the second-to-last
word in the chain. Look at the parent of `parent[target]`: this is
the third-to-last word in the chain.

Keep going until you hit the source word. Then you've walked all the
way back from `target` to `source`.

Now it's just a matter of collecting up the words along the way, and
now you have your chain!

Make sure to request a code review from your TA once you can find
adjacent words.

Good luck!

## Dictionary File

[Click through][dictionary], hit the "RAW" button, and save the text
file. Don't just save-as; tha will save an HTML version of the github
page.

[quiz-wayback]: http://web.archive.org/web/20130215052516/http://rubyquiz.com/quiz44.html
[dictionary]: ./dictionary.txt
