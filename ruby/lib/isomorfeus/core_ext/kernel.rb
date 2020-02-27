module Kernel
  def promise_after(time_ms)
    p = Promise.new
    after(time_ms) { p.resolve(true) }
    p
  end

  def on_browser?;   Isomorfeus.on_browser?;   end
  def on_ssr?;       Isomorfeus.on_ssr?;       end
  def on_server?;    Isomorfeus.on_server?;    end
  def on_desktop?;   Isomorfeus.on_desktop?;   end
  def on_ios?;       Isomorfeus.on_ios?;       end
  def on_android?;   Isomorfeus.on_android?;   end
  def on_mobile?;    Isomorfeus.on_mobile?;    end
  def on_database?;  Isomorfeus.on_database?;  end
  def on_tvos?;      Isomorfeus.on_tvos?;      end
  def on_androidtv?; Isomorfeus.on_androidtv?; end
  def on_tv?;        Isomorfeus.on_tv?;        end

  if RUBY_ENGINE == 'opal'
    def after(time_ms, &block)
      `setTimeout(#{block.to_n}, time_ms);`
    end
  else
    def after(time_ms, &block)
      sleep time_ms/1000
      block.call
    end
  end
end
