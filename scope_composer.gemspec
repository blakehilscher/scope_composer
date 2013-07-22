# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scope_composer/version"

Gem::Specification.new do |s|
  s.name        = "scope_composer"
  s.version     = ScopeComposer::VERSION
  s.authors     = ["Blake Hilscher"]
  s.email       = ["blake@hilscher.ca"]
  s.homepage    = "http://blake.hilscher.ca/"
  s.license     = "MIT"
  s.summary     = "For building scopes"
  s.description = "Scopes will be built"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 2.13"
  s.add_development_dependency "fivemat", "~> 1.2"

  s.add_runtime_dependency "activesupport", ">= 3.0.0"
end
