require File.expand_path("../simple_memoize", __FILE__)

module WillCache
  module Cacheable

    def expire_cache(method_name = nil, args = {})
      with = args[:with]
      delete_cache(method_cache_key(method_name, with))
    end
    memoize :expire_cache
    alias :clear_cache :expire_cache
    
    def cached(method_name, args = {})
      with = args[:with]

      # Rails.fetch is broken
      # http://developingsimplicity.com/posts/rails-cache-fetch
      key = method_cache_key(method_name, with)
      if cache_exist?(key)
        read_cache(key)
      else
        write_cache(key, do_send(method_name, with))
      end
    end
    memoize :cached
    alias :caches :cached

    def fetch_cache(method_name, args = {})
      with = args[:with]
      read_cache(method_cache_key(method_name, with))
    end
    memoize :fetch_cache

    def write_cache(key, value)
      Rails.cache.write(key, value)
      value
    end
    memoize :write_cache

    def read_cache(key)
      Rails.cache.read(key)
    end
    memoize :read_cache

    def delete_cache(key)
      Rails.cache.delete(key)
      true
    end
    memoize :delete_cache

    def cache_exist?(key)
      Rails.cache.exist?(key)
    end
    memoize :cache_exist?

    def method_cache_key(method_name, with)
      if self.is_a?(ActiveRecord::Base)
        base = [self.class, id, method_name].compact.join(':').gsub(' ', '_')
      else
        base = "#{self}:#{method_name}"
      end
      if with.blank?
        base
      else
        "#{base}:#{with.inspect}"
      end
    end
    memoize :method_cache_key

    def do_send(method_name, with)
      if with.blank?
        send(method_name)
      else
        send(method_name, *with)
      end
    end

  end
end



