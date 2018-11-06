module Redux
  def self.create_store(reducer, preloaded_state = nil, enhancer = nil)
    Redux::Store.new(reducer, preloaded_state, enhancer)
  end

  def self.combine_reducers(reducers)
    %x{
      var real_reducers;
      if (typeof reducers.$class === "function") {
        real_reducers = reducers.$to_n();
      } else {
        real_reducers = reducers;
      }
      return Redux.combineReducers(real_reducers);
    }
  end

  def self.apply_middleware(*middlewares)
    if middlewares.size == 1
      `Redux.applyMiddleware.apply(null, middlewares[0])`
    else
      `Redux.applyMiddleware.apply(null, middlewares)`
    end
  end

  def self.bind_action_creators(*args)
    dispatch = args.pop()
    `Redux.bindActionCreators(args, dispatch)`
  end

  def self.compose(*functions)
    `Redux.compose(functions)`
  end

  def self.create_reducer(&block)
    %x{
      return (function(previous_state, action) {
        var new_state = block.$call(Opal.Hash.$new(previous_state), Opal.Hash.$new(action));
        if (typeof new_state.$class === "function") { new_state = new_state.$to_n(); }
        return new_state;
      });
    }
  end

  def self.get_state_path(state, *path)
    path.inject(state) do |state_el, path_el|
      if !state_el.has_key?(path_el)
        state[path_el]
      else
        return nil
      end
    end
  end

  def self.set_state_path(state, *path, value)
    last_el = path.last
    path.inject(state) do |state_el, path_el|
      if path_el == last_el
        state_el[path_el] = value
        state_el[path_el]
      elsif !state_el.has_key?(path_el)
        state_el[path_el] = {}
        state_el[path_el]
      end
    end
    nil
  end
end