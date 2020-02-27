class AppStore
  class << self
    def method_missing(key, *args, &block)
      if `args.length > 0`
        # set class state, simply a dispatch
        action = { type: 'APPLICATION_STATE', name: (`key.endsWith('=')` ? key.chop : key), value: args[0] }
        Isomorfeus.store.collect_and_defer_dispatch(action)
      else
        # check store for value
        a_state = Isomorfeus.store.get_state
        if a_state.key?(:application_state) && a_state[:application_state].key?(key)
          return a_state[:application_state][key]
        end

        # otherwise return nil
        return nil
      end
    end

    alias [] method_missing
    alias []= method_missing

    alias get method_missing
    alias set method_missing

    def promise_get(key)
      Promise.new.resolve(get(key))
    end

    def promise_set(key, value)
      Promise.new.resolve(set(key, value))
    end

    def subscribe(&block)
      Isomorfeus.store.subscribe(&block)
    end

    def unsubscribe(unsubscriber)
      `unsubscriber()`
    end
  end
end
