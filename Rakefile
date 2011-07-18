require 'rake/testtask'

desc 'Default: run tests'
task :default => :test

desc 'Test WillCache'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
end
