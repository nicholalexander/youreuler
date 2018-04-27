begin
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
  
  RSpec::Core::RakeTask.new(:spec)
  RuboCop::RakeTask.new
rescue LoadError
end

task default: %w[hello spec rubocop]

task :hello do
  puts 'hello from youreul!'
end
