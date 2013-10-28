# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'looker_pull/version'

Gem::Specification.new do |spec|
  spec.name          = "looker_pull"
  spec.version       = LookerPull::VERSION
  spec.authors       = ["Chris Homer"]
  spec.email         = ["chris@thredup.com"]
  spec.description   = %q{A gem for pulling data from looker based on a url}
  spec.summary       = %q{A gem for pulling data from looker based on a url}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
