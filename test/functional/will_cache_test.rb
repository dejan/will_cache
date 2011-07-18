require File.expand_path('../../test_helper', __FILE__)

class Rails
  def self.cache
  end
end

class User < ActiveRecord::Base
  has_many :articles
  acts_as_cached
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

  def test_cached
    mock(Rails.cache).fetch("User[1]#articles") { @user.articles }
    assert_equal @user.articles, @user.cached(:articles)
  end

  def test_expire_cache
    mock(Rails.cache).delete("User[1]#articles")
    @user.expire_cache(:articles)
  end
end
