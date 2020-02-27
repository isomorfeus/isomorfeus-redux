module Redux
  class Store
    include Native::Wrapper

    def self.add_middleware(middleware)
      if Isomorfeus.store
        `console.warning("Adding middleware after Store initialization may have side effects! Saving state and initializing new store with restored state!")`
        middlewares << middleware
        preloaded_state = Isomorfeus.store.get_state
        init!
      else
        middlewares << middleware
      end
    end

    def self.add_reducer(reducer)
      if Isomorfeus.store
        # if the store has been initalized already, add the reducer to the instance
        Isomorfeus.store.add_reducer(reducer)
      else
        # otherwise just add it to the reducers, so that they will be used when initializing the store
        preloaded_state[reducer.keys.first] = {} unless preloaded_state.has_key?(reducer.keys.first)
        reducers.merge!(reducer)
      end
    end

    def self.add_reducers(new_reducers)
      if Isomorfeus.store
        # if the store has been initalized already, add the reducer to the instance
        Isomorfeus.store.add_reducers(new_reducers)
      else
        # otherwise just add it to the reducers, so that they will be used when initializing the store
        new_reducers.each do |key, value|
          add_reducer(key => value)
        end
      end
    end

    # called from Isomorfeus.init
    def self.init!
      next_reducer = Redux.combine_reducers(@reducers)
      if middlewares.any?
        enhancer = Redux.apply_middleware(middlewares)
        Redux::Store.new(next_reducer, preloaded_state, enhancer)
      else
        Redux::Store.new(next_reducer, preloaded_state)
      end
    end

    def self.middlewares
      @middlewares ||= []
    end

    def self.preloaded_state_merge!(ruby_hash)
      preloaded_state.merge!(ruby_hash)
    end

    def self.preloaded_state
      @preloaded_state ||= {}
    end

    def self.preloaded_state=(ruby_hash)
      @preloaded_state = ruby_hash
    end

    def self.reducers
      @reducers ||= {}
    end

    def initialize(reducer, preloaded_state = `null`, enhancer = `null`)
      @deferred_actions = {}
      @deferred_dispatcher = nil
      @last_dispatch_time = Time.now
      %x{
        var compose = (typeof window === 'object' && window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__) || Opal.global.Redux.compose;
        var devext_enhance;
        if (typeof window === 'object' && window.__REDUX_DEVTOOLS_EXTENSION__) { devext_enhance = window.__REDUX_DEVTOOLS_EXTENSION__(); }
        var real_preloaded_state;
        if (typeof preloaded_state.$class === "function" && preloaded_state.$class() == "Hash") {
          if (preloaded_state.$size() == 0) {
            real_preloaded_state = null;
          } else {
            real_preloaded_state = preloaded_state.$to_n();
          }
        } else if (preloaded_state == nil) {
          real_preloaded_state = null;
        } else {
          real_preloaded_state = preloaded_state;
        }
        if (enhancer && real_preloaded_state) {
          this.native = Opal.global.Redux.createStore(reducer, real_preloaded_state, compose(enhancer));
        } else if (real_preloaded_state) {
          this.native = Opal.global.Redux.createStore(reducer, real_preloaded_state, devext_enhance);
        } else if (enhancer) {
          this.native = Opal.global.Redux.createStore(reducer, compose(enhancer));
        } else {
          this.native = Opal.global.Redux.createStore(reducer, devext_enhance);
        }
      }
    end

    def add_reducer(reducer)
      self.class.reducers.merge!(reducer)
      next_reducer = Redux.combine_reducers(self.class.reducers)
      replace_reducer(next_reducer)
    end

    def add_reducers(new_reducers)
      self.class.reducers.merge!(new_reducers)
      next_reducer = Redux.combine_reducers(self.class.reducers)
      replace_reducer(next_reducer)
    end

    def dispatch(action)
      %x{
        if (typeof action.$class === "function" && action.$class() == "Hash") {
          this.native.dispatch(action.$to_n());
        } else {
          this.native.dispatch(action);
        }
      }
    end

    def get_state
      Hash.new(`this.native.getState()`)
    end

    def collect_and_defer_dispatch(action)
      if !Isomorfeus.on_ssr?
        type = action.delete(:type)
        @deferred_actions[type] = [] unless @deferred_actions.key?(type)
        @deferred_actions[type].push(action)
        @last_dispatch_time = `Date.now()`
        `console.log(#@last_dispatch_time)`
        deferred_dispatcher(`Date.now()`) unless @deferred_dispatcher
      else
        dispatch(action)
      end
      nil
    end

    def replace_reducer(next_reducer)
      `this.native.replaceReducer(next_reducer)`
    end

    # returns function needed to unsubscribe the listener
    def subscribe(&listener)
      `this.native.subscribe(function() { return listener.$call(); })`
    end

    private

    def deferred_dispatcher(first)
      @deferred_dispatcher = true
      %x{
        setTimeout(function() {
          if (#{wait_longer?(first)}) { #{deferred_dispatcher(first)} }
          else { #{dispatch_deferred_dispatches} }
        }, 10)
      }
    end

    def dispatch_deferred_dispatches
      `console.log(Date.now())`
      @deferred_dispatcher = false
      actions = @deferred_actions
      @deferred_actions = {}
      actions.each do |type, data|
        dispatch(type: type, collected: data)
      end
    end

    def wait_longer?(first)
      t = `Date.now()`
      time_since_first = `t - first`
      `console.log('delta', time_since_first)`
      return true if `typeof Opal.React !== 'undefined' && typeof Opal.React.render_buffer !== 'undefined' && Opal.React.render_buffer.length > 0 && time_since_first < 1000`
      return false if time_since_first > 100 # ms
      return false if (`t - #@last_dispatch_time`) > 9 # ms
      return true
    end
  end
end
