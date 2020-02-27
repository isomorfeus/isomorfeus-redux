require 'opal'
require 'isomorfeus/execution_environment'
require 'isomorfeus/core_ext/kernel'

if RUBY_ENGINE == 'opal'
  require 'native'
  require 'promise'
  require 'securerandom'
  require 'isomorfeus/core_ext/hash/deep_merge'
  require 'redux'
  require 'redux/store'
  require 'redux/reducers'
  require 'isomorfeus/redux_config'
  require 'isomorfeus/browser_store_api'
  require 'local_store'
  require 'session_store'
  require 'app_store'

  Redux::Reducers::add_application_reducers_to_store
  Isomorfeus.init_store
else
  opal_path = Gem::Specification.find_by_name('opal').full_gem_path
  promise_path = File.join(opal_path, 'stdlib', 'promise.rb')
  require promise_path
  require 'redux/version'

  Opal.append_path(__dir__.untaint)

  path = File.expand_path('app')
  Opal.append_path(path) unless Opal.paths.include?(path)
end
