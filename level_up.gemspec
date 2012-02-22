# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "level_up/version"

Gem::Specification.new do |s|
  s.name        = "level_up"
  s.version     = LevelUp::VERSION
  s.authors     = ["Nicolas NARDONE"]
  s.email       = ["nico.nardone@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Badge and achievement system for Rails}
  s.description = %q{Define badges and points needed to unlock them. Track who has badge}

  s.rubyforge_project = "level_up"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rails"
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'sqlite3-ruby'
  
  s.add_runtime_dependency 'rails'
end
