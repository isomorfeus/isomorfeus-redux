module Isomorfeus
  module BrowserStoreApi
    def promise_get(key)
      Promise.new.resolve(get(key))
    end

    def promise_set(key, value)
      Promise.new.resolve(set(key, value))
    end

    def promise_delete(key)
      Promise.new.resolve(delete(key))
    end

    def promise_clear
      Promise.new.resolve(clear)
    end

    def subscribe(&block)
      key = SecureRandom.uuid
      subscribers[key] = block
      key
    end

    def unsubscribe(key)
      subscribers.delete(key)
      nil
    end

    def notify_subscribers
      return if subscribers.empty?
      after 0 do
        subscribers.each_value do |block|
          block.call
        end
      end
    end

    def subscribers
      @subscribers ||= {}
    end
  end
end
