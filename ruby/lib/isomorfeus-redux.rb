if RUBY_ENGINE == 'opal'
  require 'native'
  require 'promise'
  require 'isomorfeus/core_ext/hash/deep_merge'
  require 'redux/version'
  require 'redux'
  require 'redux/store'
  require 'redux/reducers'
  require 'isomorfeus/redux_config'

  Redux::Reducers::add_application_reducers_to_store
  Isomorfeus.init_store
else
  require 'opal'
  require 'isomorfeus/promise'
  require 'redux/version'

  Opal.append_path(__dir__.untaint)

  path = File.expand_path('isomorfeus')
  Opal.append_path(path) unless Opal.paths.include?(path)
end
