module WillCache
  module Cacheable

    def expire_cache(method_name = nil, args = {})
      with = args[:with]
      delete_cache(method_cache_key(method_name, with))
    end
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
    alias :caches :cached

    def fetch_cache(method_name, args = {})
      with = args[:with]
      read_cache(method_cache_key(method_name, with))
    end

    def write_cache(key, value)
      Rails.cache.write(key, value)
      value
    end

    def read_cache(key)
      Rails.cache.read(key)
    end

    def delete_cache(key)
      Rails.cache.delete(key)
      true
    end

    def cache_exist?(key)
      Rails.cache.exist?(key)
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



