require File.expand_path('../../test_helper', __FILE__)

class Rails
  def self.cache
  end
end

class User < ActiveRecord::Base
  has_many :articles
  acts_as_cached

  after_update :expire_cache
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
  end

  def test_cached_on_class_method
    mock(Rails.cache).fetch("User:count") { 1 }
    assert_equal 1, User.cached(:count)
  end

  def test_cached_on_instance_method
    mock(Rails.cache).fetch("User:1:articles") { @user.articles }
    assert_equal @user.articles, @user.cached(:articles)
  end

  def test_expire_cache
    mock(Rails.cache).delete("User:1:articles")
    @user.expire_cache(:articles)
  end

  def test_expire_cache2
    mock(Rails.cache).delete("User:1:random:2")
    @user.expire_cache('random:2')
  end

  def test_fetch_cache
    mock(Rails.cache).read("User:1:articles")
    @user.fetch_cache(:articles)
  end

  def test_expire_cache_after_update
    mock(Rails.cache).delete("User:#{@user.id}")
    @user.name = 'dejan'
    @user.save!
  end

end
