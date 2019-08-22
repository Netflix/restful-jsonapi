# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restful/jsonapi/version'

Gem::Specification.new do |spec|
  spec.name          = "restful-jsonapi"
  spec.version       = Restful::Jsonapi::VERSION
  spec.authors       = ["Zach Wentz", "Ryan Johnston", "David Lee", "Adam Gross"]
  spec.email         = ["zwentz@netflix.com", "ryanj@netflix.com", "dalee@netflix.com", "agross@netflix.com"]
  spec.summary       = %q{Nice type and params for temporary JSONAPI support.}
  spec.description   = %q{Nice type and params for temporary JSONAPI support.}
  spec.homepage      = "https://github.com/Netflix/restful-jsonapi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", [">=4", "< 7"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
