class SessionStore
  extend Isomorfeus::BrowserStoreApi

  class << self
    def method_missing(key, *args, &block)
      if Isomorfeus.on_browser?
        if `args.length > 0`
          key = `key.endsWith('=')` ? key.chop : key
          value = args[0]
          `Opal.global.sessionStorage.setItem(key, value)`
          notify_subscribers
          value
        else
          # check store for value
          value = `Opal.global.sessionStorage.getItem(key)`
          return value if value
        end
      end
      # otherwise return nil
      return nil
    end

    alias [] method_missing
    alias []= method_missing

    alias get method_missing
    alias set method_missing

    def delete(key)
      `Opal.global.sessionStorage.removeItem(key)`
      notify_subscribers
      nil
    end

    def clear
      `Opal.global.sessionStorage.clear()`
      notify_subscribers
      nil
    end
  end
end
