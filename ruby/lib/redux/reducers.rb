# TODO implement Isomorfeus.store.app_store or Isomorfeus.app_store

module Redux
  module Reducers
    def self.add_application_reducers_to_store
      unless @_application_reducers_added
        @_application_reducers_added = true
        app_reducer = Redux.create_reducer do |prev_state, action|
          case action[:type]
          when 'APPLICATION_STATE'
            new_state = {}.merge!(prev_state) # make a copy of state
            new_state.merge!(action[:name] => action[:value])
            new_state
          else
            prev_state
          end
        end

        Redux::Store.add_reducers(application_state: app_reducer)
      end
    end
  end
end
