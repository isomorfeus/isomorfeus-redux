if RUBY_ENGINE == 'opal'
  require 'native'
  require 'promise'
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

  if Dir.exist?('isomorfeus')
    # Opal.append_path(File.expand_path(File.join('isomorfeus', 'components')))
    Opal.append_path(File.expand_path('isomorfeus')) unless Opal.paths.include?(File.expand_path('isomorfeus'))
  end
end