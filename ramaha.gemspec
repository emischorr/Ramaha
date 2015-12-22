# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ramaha/version"

Gem::Specification.new do |s|
  s.name        = "ramaha"
  s.version     = Ramaha::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Enrico Mischorr"]
  s.email       = ["enrico@mischorr.de"]
  s.homepage    = ""
  s.summary     = %q{Gem to provide wrappers for the YAMAHA AVR web interface}
  s.description = %q{Gem to provide wrappers for the YAMAHA AVR web interface}

  s.rubyforge_project = "ramaha"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri'

  s.add_development_dependency "rspec"
  
  s.add_dependency "rest-client"
end
