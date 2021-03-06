require File.expand_path('../../test_helper', __FILE__)
require 'active_support/cache'
require 'FileUtils'
class Rails
  def self.cache
    @@cache
  end
  
  def self.cache=(c)
    @@cache = c
  end
end

class User < ActiveRecord::Base
  has_many :articles
  acts_as_cached

  after_update :expire_cache
  
  def self.sum(a, b)
    a + b
  end
end

class Article < ActiveRecord::Base
  belongs_to :user
  acts_as_cached
end

class WillCacheTest < Test::Unit::TestCase
  def setup
    fixtures_dir = File.dirname(__FILE__) + '/../fixtures'
    connections = YAML.load_file("#{fixtures_dir}/database.yml")
    ActiveRecord::Base.establish_connection(connections['sqlite3'])
    ActiveRecord::Migration.verbose = false
    load "#{fixtures_dir}/schema.rb"
    
    @user = User.create!
    @user.articles << Article.new(:body => 'hey')
    FileUtils.rm_rf('tmp/cache')
    Rails.cache = ActiveSupport::Cache::FileStore.new('tmp/cache')
  end

  def test_cached_on_class_method
    key = "User:count"
    mock(Rails.cache).exist?(key) { false }
    mock(Rails.cache).write(key, 1) { 1 }
    assert_equal 1, User.cached(:count)
  end

  def test_cached_on_class_method_with_args
    assert_equal 5, User.cached(:sum, :with => [2, 3])
  end

  def test_cached_on_instance_method
    key = "User:1:articles"
    mock(Rails.cache).exist?(key) { false }
    mock(Rails.cache).write(key, @user.articles) { @user.articles }
    assert_equal @user.articles, @user.cached(:articles)
  end

  def test_cached_on_instance_method_on_hit
    key = "User:1:articles"
    mock(Rails.cache).exist?(key) { true }
    mock(Rails.cache).read(key) { @user.articles }
    assert_equal @user.articles, @user.cached(:articles)
  end

  def test_expire_cache
    mock(Rails.cache).delete("User:1:articles")
    assert @user.expire_cache(:articles)
  end

  def test_expire_cache2
    mock(Rails.cache).delete("User:1:random:2")
    assert @user.expire_cache('random:2')
  end

  def test_fetch_cache
    mock(Rails.cache).read("User:1:articles")
    @user.fetch_cache(:articles)
  end

  def test_refresh_cache
    assert_equal 1, User.cached(:count)
    assert_equal 1, User.fetch_cache(:count)
    User.create!
    assert_equal 1, User.fetch_cache(:count)
    assert_equal 2, User.refresh_cache(:count)
    assert_equal 2, User.fetch_cache(:count)
  end

  def test_expire_cache_after_update
    mock(Rails.cache).delete("User:#{@user.id}")
    @user.name = 'dejan'
    @user.save!
  end

end
