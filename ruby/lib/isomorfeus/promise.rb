opal_path = Gem::Specification.find_by_name('opal').full_gem_path
promise_path = File.join(opal_path, 'stdlib', 'promise.rb')
require promise_path
