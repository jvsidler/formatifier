# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'formatifier/version'

Gem::Specification.new do |gem|
  gem.name          = "formatifier"
  gem.version       = Formatifier::VERSION
  gem.authors       = ["Jim Sidler"]
  gem.email         = ["jim@jimsidler.com"]
  gem.description   = %q{Custom string formatter}
  gem.summary       = %q{Coerce strings to have delimiters in places you define and replace characters with different alphabets}
  gem.homepage      = "https://github.com/jvsidler/formatifier"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
