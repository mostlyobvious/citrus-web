# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'citrus/web/version'

Gem::Specification.new do |spec|
  spec.name          = "citrus-web"
  spec.version       = Citrus::Web::VERSION
  spec.authors       = ["Paweł Pacana"]
  spec.email         = ["pawel.pacana@syswise.eu"]
  spec.description   = %q{Citrus continous integration web component.}
  spec.summary       = %q{Citrus continous integration web component.}
  spec.homepage      = "http://citrus-ci.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "citrus-core", "~> 0.0.4"
  spec.add_dependency "webmachine",  "~> 1.2.1"
  spec.add_dependency "puma",        "~> 2.0"
  spec.add_dependency "rb-kqueue",   "~> 0.2.0"
  spec.add_dependency "rb-inotify",  "~> 0.9.0"
  spec.add_dependency "dependor",    "~> 1.0"
  spec.add_dependency "ffi-rzmq",    "~> 1.0.3"
  spec.add_dependency "m2r",         "2.1.0.pre"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmachine-test", "~> 0.2.1"
  spec.add_development_dependency "rspec", "~> 2.13"
  spec.add_development_dependency "bogus", "~> 0.1"
  spec.add_development_dependency "coveralls", "~> 0.7"
  spec.add_development_dependency "foreman"
end
