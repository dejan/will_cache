module WillCache
  module Cacheable

    def cache
      Rails.cache
    end

    def expire_cache(method_name = nil, args = {})
      with = args[:with]
      cache.delete(method_cache_key(method_name, with))
      true
    end
    alias :clear_cache :expire_cache
    
    def cached(method_name, args = {})
      with = args[:with]

      # Rails.fetch is broken
      # http://developingsimplicity.com/posts/rails-cache-fetch
      key = method_cache_key(method_name, with)
      if cache.exist?(key)
        cache.read(key)
      else
        cache.write(key, do_send(method_name, with))
      end
    end
    alias :caches :cached

    def fetch_cache(method_name, args = {})
      with = args[:with]
      cache.read(method_cache_key(method_name, with))
    end

    def write_cache(key, value, ttl = nil)
      cache.write(key, value, :expires_in => ttl)
    end

    def read_cache(key)
      cache.read(key)
    end

    def do_send(method_name, with)
      if with.blank?
        send(method_name)
      else
        send(method_name, with)
      end
    end

    def method_cache_key(method_name, with)
      if self.is_a?(ActiveRecord::Base)
        base = [self.class, id, method_name].compact.join(':').gsub(' ', '_')
      else
        base = "#{self}:#{method_name}"
      end
      if with.blank?
        base
      else
        "#{base}:#{with}"
      end
    end
  end
end



