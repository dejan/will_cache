require File.expand_path("../will_cache/cacheable", __FILE__)

module WillCache
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    include Cacheable
    def acts_as_cached
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    include Cacheable
  end
end

ActiveRecord::Base.send :include, WillCache
