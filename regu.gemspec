# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'regu/version'

Gem::Specification.new do |gem|
  gem.name          = 'regu'
  gem.version       = Regu::VERSION
  gem.authors       = %w[Eli\ Fox-Epstein]
  gem.email         = %w[eli@fox-epste.in]
  gem.description   = 'C-based regular expressions for Ruby'
  gem.summary       = 'C-based regular expressions for Ruby'
  gem.homepage      = 'http://github.com/elitheeli/regu'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w[lib]
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

  gem.add_dependency 'RubyInline'
  gem.add_dependency 'treetop'
end
