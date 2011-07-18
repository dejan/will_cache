module WillCache
  module Cacheable
    def expire_cache(method_name, args = {})
      with = args[:with]
      Rails.cache.delete(method_cache_key(method_name, with))
    end

    def cached(method_name, args = {})
      with = args[:with]
      Rails.cache.fetch(method_cache_key(method_name, with)) {
        do_send(method_name, with)
      }
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
        base = "#{self.class}:#{id}:#{method_name}"
      else
        base = "#{self}:#{method_name}"
      end
      if with.blank?
        base
      else
        "#{base}(#{with.inspect})"
      end
    end
  end
end



