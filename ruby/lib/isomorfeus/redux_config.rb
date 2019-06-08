module Isomorfeus
  class << self
    attr_reader :store_initialized
    attr_reader :store

    def init_store
      return if store_initialized
      @store_initialized = true
      force_init_store!
    end

    def force_init_store!
      # at least one reducer must have been added at this stage
      # this happened in isomorfeus-react.rb, where the component reducers were added
      @store = Redux::Store.init!
      `Opal.Isomorfeus.store = #@store`
    end
  end
end
