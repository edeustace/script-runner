# -*- encoding: utf-8 -*-
require File.expand_path('../lib/script-runner/version', __FILE__)

name = "script-runner"

Gem::Specification.new do |gem|
  gem.authors       = ["ed.eustace"]
  gem.email         = ["ed.eustace@gmail.com"]
  gem.description   = %q{it just runs scripts}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/edeustace/script-runner"
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = name
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 2.0.0'
  gem.version       = ScriptRunner::VERSION
  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "rake", "~> 10.1.0"
  gem.add_dependency "logging", "~> 1.8.1"
  gem.add_dependency "thor"

end
