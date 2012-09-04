# Regu

Regu is a fun experiment to see if it's viable to make a extremely fast, limited-power regular expression engine for Ruby backed by DFAs.

## Features

- Kleene star: `(regexp)*`
- Plus operator: `(regexp)+`
- Optional operator: `(regex)?`
- Fixed repetition: `(regex){3}`
- Range repetition: `(regex){2,5}`
- Union: `reg1 | reg2`
- Concat: `abc(d|e|f)`
- Wildcard: `Hello .orld`
- Escaping: `\{ \( \[`
- Character classes: `[^abc]`

## Usage

Add the gem to your Gemfile.

    gem 'regu'

Require it.

    require 'regu'
    
Use it.

    /some_regex/.regu
    
or

    Regu['Hello (World|Eli)']

## Limitations

DFA-based regular expression engines can't really handle lookahead or captures. So, Regu should be used strictly to see if something matches a particular format.

Also, right now, DFA construction is painfully slow.

## Performance

From the benchmarks.rb file, we get:

                  user     system      total        real
    native  159.950000   0.180000 160.130000 (163.428341)
    regu-c    0.010000   0.000000   0.010000 (  0.007991)
    regu-rb   0.080000   0.000000   0.080000 (  0.079797)

    C-ext Regu is 20451.357371 times faster than native
     Ruby Regu is 2048.050437 times faster than native

We're pretty quick. 

## To-Do

*Lazy defaults.* Hijack `Regex#match` and use Regu if it makes sense, but if a method is called on some `MatchData` object
that we should return, then go back and use Ruby's `Regexp`. This really only makes sense if we can figure out the context. Since
construction for us is so expensive and such, maybe we should only do this if the regexp is frozen or something to indicate that
that it's initialized ahead-of-time.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add comprehensive specs
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
