# -*- encoding: utf-8 -*-
require_relative 'lib/redux/version.rb'

Gem::Specification.new do |s|
  s.name          = 'isomorfeus-redux'
  s.version       = Redux::VERSION

  s.authors       = ['Jan Biedermann']
  s.email         = ['jan@kursator.com']
  s.homepage      = 'http://isomorfeus.com'
  s.summary       = 'Redux for Opal Ruby.'
  s.license       = 'MIT'
  s.description   = 'Use a global store and write reducers for it in Opal Ruby.'

  s.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(gemfiles|s)/}) }
  # s.test_files    = `git ls-files -- {test,s,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'opal', '>= 0.11.0'
end
