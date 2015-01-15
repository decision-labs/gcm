# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "gcm"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kashif Rasul", "Shoaib Burq"]
  s.email       = ["kashif@spacialdb.com", "shoaib@spacialdb.com"]
  s.homepage    = "https://github.com/spacialdb/gcm"
  s.summary     = %q{send data to Android applications on Android devices}
  s.description = %q{gcm is a service that helps developers send data from servers to their Android applications on Android devices.}
  s.license     = "MIT"

  s.required_ruby_version     = '>= 1.9.3'

  s.rubyforge_project = "gcm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('httparty')
  s.add_dependency('json')
end
