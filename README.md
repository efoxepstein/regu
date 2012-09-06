# Regu

Regu is a fun experiment to see if it's viable to make a extremely fast, limited-power regular expression engine for Ruby backed by DFAs.

## Features

We should essentially duplicate all features of vanilla regexps. Kleene stars and other repetition operators, union, concatenations, wildcards, escaping, character classes, etc.

## Usage

Add the gem to your Gemfile.

    gem 'regu'

Require it.

    require 'regu'
    
Use it.

    /some_regex/.regu
    
### Caching

The DFA construction process can be time-intensive. Use

    /some_regex/.cached_regu
    
to deal with this. The first call to `cached_regu` will create the DFA and marshal it into a file within `.regu/`. You can change the caching folder by passing a string to `cached_regu`.

## Limitations

DFA-based regular expression engines can't really handle lookahead or captures. So, Regu should be used strictly to see if something matches a particular format.

Also, right now, DFA construction is painfully slow.

## Performance

From `benchmarks.rb`, I see we're between 4.58 and 26764 times faster than vanilla Regexps. That's pretty quick. There are plenty of regexps that would be infeasible to run without Regu.

## To-Do

*Lazy defaults.* Hijack `Regex#match` and use Regu if it makes sense, but if a method is called on some `MatchData` object
that we should return, then go back and use Ruby's `Regexp`. This really only makes sense if we can figure out the context. Since
construction for us is so expensive and such, maybe we should only do this if the regexp is frozen or something to indicate that
that it's initialized ahead-of-time.

*Better test data*. Can we find real world examples where Regu smokes the competition?

*DFA minimization*. We can reduce our memory footprint by minimizing.

*`is_a? Regexp`*. We should be a regexp so we can be used in things like `String#split`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add comprehensive specs
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
