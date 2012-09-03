# Regu

Regu is a fun experiment to see if it's viable to make fast, limited-power regular expressions for Ruby backed by DFAs. Currently, it is pretty fast (about 2000 times faster than the native Ruby solution for big regular expressions).

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

## Limitations

DFA-based regular expression engines can't really handle lookahead or captures. So, Regu should be used strictly to see if something matches a particular format.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add comprehensive specs
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
