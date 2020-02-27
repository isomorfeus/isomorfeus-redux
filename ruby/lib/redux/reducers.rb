module Redux
  module Reducers
    def self.add_application_reducers_to_store
      unless @_application_reducers_added
        @_application_reducers_added = true
        app_reducer = Redux.create_reducer do |prev_state, action|
          case action[:type]
          when 'APPLICATION_STATE'
            if action.key?(:set_state)
              action[:set_state]
            else
              new_state = {}.merge!(prev_state) # make a copy of state
              if action.key?(:collected)
                action[:collected].each do |act|
                  new_state.merge!(act[:name] => act[:value])
                end
              else
                new_state.merge!(action[:name] => action[:value])
              end
              new_state
            end
          else
            prev_state
          end
        end

        instance_reducer = Redux.create_reducer do |prev_state, action|
          case action[:type]
          when 'INSTANCE_STATE'
            if action.key?(:set_state)
              action[:set_state]
            else
              new_state = {}.merge!(prev_state) # make a copy of state
              if action.key?(:collected)
                action[:collected].each do |act|
                  new_state[act[:object_id]] = {} unless new_state.key?(act[:object_id])
                  new_state[act[:object_id]].merge!(act[:name] => act[:value])
                end
              else
                new_state[action[:object_id]] = {} unless new_state.key?(action[:object_id])
                new_state[action[:object_id]].merge!(action[:name] => action[:value])
              end
              new_state
            end
          else
            prev_state
          end
        end

        class_reducer = Redux.create_reducer do |prev_state, action|
          case action[:type]
          when 'CLASS_STATE'
            if action.key?(:set_state)
              action[:set_state]
            else
              new_state = {}.merge!(prev_state) # make a copy of state
              if action.key?(:collected)
                action[:collected].each do |act|
                  new_state[act[:class]] = {} unless new_state.key?(act[:class])
                  new_state[act[:class]].merge!(act[:name] => act[:value])
                end
              else
                new_state[action[:class]] = {} unless new_state.key?(action[:class])
                new_state[action[:class]].merge!(action[:name] => action[:value])
              end
              new_state
            end
          else
            prev_state
          end
        end
        Redux::Store.preloaded_state_merge!(application_state: {}, instance_state: {}, class_state: {})
        Redux::Store.add_reducers(application_state: app_reducer, instance_state: instance_reducer, class_state: class_reducer)
      end
    end
  end
end
