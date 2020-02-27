module Isomorfeus
  if RUBY_ENGINE == 'opal'
    class << self
      attr_accessor :on_browser
      attr_accessor :on_ssr
      attr_accessor :on_server
      attr_accessor :on_desktop
      attr_accessor :on_ios
      attr_accessor :on_android
      attr_accessor :on_mobile
      attr_accessor :on_database
      attr_accessor :on_tvos
      attr_accessor :on_androidtv
      attr_accessor :on_tv

      def on_browser?
        # true if running on browser
        @on_browser
      end

      def on_ssr?
        # true if running in server side rendering in restricted node js vm
        @on_ssr
      end

      def on_server?
        # true if running on server
        @on_server
      end

      def on_desktop?
        # true if running in electron
        @on_desktop
      end

      def on_ios?
        # true if running in react-native on ios
        @on_ios
      end

      def on_android?
        # true if running in react-native on android
        @on_android
      end

      def on_mobile?
        # true if running in react-native
        @on_mobile
      end

      def on_database?
        # true if running in database context
        @on_database
      end

      def on_tvos?
        # true if running in react-native on tvOS
        @on_tvos
      end

      def on_androidtv?
        # true if running in react-native on androidtv
        @on_androidtv
      end

      def on_tv?
        # true if running in react-native on a tv
        @on_tv
      end
    end

    self.on_ssr       = `(typeof process   === 'object' && typeof process.release === 'object' && typeof process.release.name === 'string' && process.release.name === 'node') ? true : false`
    self.on_desktop   = `(typeof navigator === 'object' && typeof navigator.userAgent === 'string' && navigator.userAgent.toLowerCase().indexOf(' electron/') > -1) ? true : false`
    self.on_ios       = `(typeof Platform  === 'object' && typeof Platform.OS === 'string' && Platform.OS.toLowerCase().includes('ios')) ? true : false`
    self.on_android   = `(typeof Platform  === 'object' && typeof Platform.OS === 'string' && Platform.OS.toLowerCase().includes('android')) ? true : false`
    self.on_mobile    = self.on_ios? || self.on_android?
    self.on_database  = false
    self.on_browser   = !self.on_ssr? && !self.on_desktop? && !self.on_mobile? && !self.on_database?
    self.on_server    = false
    self.on_tvos      = false
    self.on_androidtv = false
    self.on_tv        = false
  else
    class << self
      def on_ssr?;       false; end
      def on_desktop?;   false; end
      def on_ios?;       false; end
      def on_android?;   false; end
      def on_mobile?;    false; end
      def on_database?;  false; end
      def on_browser?;   false; end
      def on_tvos?;      false; end
      def on_androidtv?; false; end
      def on_tv?;        false; end

      def on_server?
        true # so true ...
      end
    end
  end
end
