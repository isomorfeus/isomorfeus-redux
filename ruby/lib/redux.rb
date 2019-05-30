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
      return Opal.global.Redux.combineReducers(real_reducers);
    }
  end

  def self.apply_middleware(*middlewares)
    if middlewares.size == 1
      `Opal.global.Redux.applyMiddleware.apply(null, middlewares[0])`
    else
      `Opal.global.Redux.applyMiddleware.apply(null, middlewares)`
    end
  end

  def self.bind_action_creators(*args)
    dispatch = args.pop
    `Opal.global.Redux.bindActionCreators(args, dispatch)`
  end

  def self.compose(*functions)
    `Opal.global.Redux.compose(functions)`
  end

  def self.create_reducer(&block)
    %x{
      return (function(previous_state, action) {
        if (!previous_state) { previous_state = {}; }
        var previous_state_hash = Opal.Hash.$new(previous_state);
        var new_state_hash = block.$call(previous_state_hash, Opal.Hash.$new(action));
        if (previous_state_hash === new_state_hash) { return previous_state; }
        if (typeof new_state_hash.$class === "function") { return new_state_hash.$to_n(); }
        return previous_state;
      });
    }
  end

  def self.delete_state_path(state, *path)
    size = path.size - 1
    set_state_path(state, *path[0..-2], nil)
    (2...size).each do |i|
      val = get_state_path(state, *path[0..-i])
      break if val.keys.size > 1
      set_state_path(state, *path[0..-i], nil)
    end
  end

  def self.fetch_by_path(*path)
    # get active redux component
    # (There should be a better way to get the component)
    %x{
      var active_component = Opal.React.active_redux_component();
      var current_state;
      var final_data;
      var path_last = path.length - 1;
      if (path[path_last].constructor === Array) {
        path[path_last] = JSON.stringify(path[path_last]);
      }
      if (active_component) {
        // try to get data from component state or props or store
        current_state = active_component.data_access()
        if (current_state) {
          final_data = path.reduce(function(prev, curr) { return prev && prev[curr]; }, current_state);
          // if final data doesn't exist, its set to 'null', so nil or false are ok as final_data
          if (final_data !== null && typeof final_data !== "undefined") { return final_data; }
        }
      } else {
        // try to get data from store
        current_state = Isomorfeus.store.native.getState();
        final_data = path.reduce(function(prev, curr) { return prev && prev[curr]; }, current_state);
        // if final data doesn't exist, its set to 'null', so nil or false are ok as final_data
        if (final_data !== null && typeof final_data !== "undefined") { return final_data; }
      }
      return null;
    }
  end

  def self.get_state_path(state, *path)
    path.inject(state) do |state_el, path_el|
      if state_el.has_key?(path_el)
        state_el[path_el]
      else
        return nil
      end
    end
  end

  def self.register_used_store_path(*path)
    %x{
      var active_component = Opal.React.active_redux_component();
      if (active_component) { active_component.register_used_store_path(path); }
    }
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
      else
        state_el[path_el]
      end
    end
    nil
  end
end