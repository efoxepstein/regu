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
    native    8.880000   0.010000   8.890000 (  8.933724)
    regu-c    0.010000   0.000000   0.010000 (  0.009275)
    regu-rb   0.200000   0.000000   0.200000 (  0.208004)

We're pretty quick. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add comprehensive specs
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
