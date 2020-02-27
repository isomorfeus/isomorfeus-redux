# -*- encoding: utf-8 -*-
require_relative 'lib/redux/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-redux'
  s.version       = Redux::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'http://isomorfeus.com'
  s.summary       = 'Redux and Stores for Isomorfeus.'
  s.license       = 'MIT'
  s.description   = 'Use different stores within Isomorfeus and write reducers for redux.'
  s.metadata      = { "github_repo" => "ssh://github.com/isomorfeus/gems" }
  s.files         = `git ls-files -- {lib,LICENSE,README.md}`.split("\n")
  # s.test_files    = `git ls-files -- {test,s,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'opal', '>= 1.0.0'
  s.add_development_dependency 'rake'
end
