# -*- encoding: utf-8 -*-
require File.expand_path('../lib/factory_inspector/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Kennedy"]
  gem.email         = ["david.kennedy@examtime.com"]
  gem.description   = %q{This very simple gem generates reports on how FactoryGirl factories are being used in your test runs.}
  gem.summary       = %q{Reports on how FactoryGirl is used in test runs.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "factory_inspector"
  gem.require_paths = ["lib"]
  gem.version       = FactoryInspector::VERSION

  gem.add_development_dependency 'rspec'
end
