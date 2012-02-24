require 'bundler/gem_tasks'
require 'rake/testtask'

desc 'Default: run tests'
task :default => :test

desc 'Test the has_badges gem'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.test_files = FileList['spec/**/*_spec.rb']	
  t.verbose = true
end
