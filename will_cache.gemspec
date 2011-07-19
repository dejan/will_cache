Gem::Specification.new do |gem|
  gem.name = 'will_cache'
  gem.version = '0.0.3'
  gem.date = Date.today.to_s

  gem.summary = "Drop-in replacement for cache_fu that uses Rails.cache store"
  gem.description = "WillCache provides simple API for caching ActiveRecord objects that uses ActiveSupport Cache Store internally so that it's trivial to switch cache storage. WillCache API is heavily inspired by excellent but no longer maintained cache_fu plugin and one of the goals of the gem is to provide drop-in replacement for it."
  
  gem.authors  = ['Dejan Simic']
  gem.email    = 'desimic@gmail.com'
  gem.homepage = 'http://github.com/dejan/will_cache'

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*',
                  'README*', 'LICENSE'] & `git ls-files -z`.split("\0")
end

