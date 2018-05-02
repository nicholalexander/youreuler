# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RSpec::Core::RakeTask.new(:spec)
  RuboCop::RakeTask.new
rescue LoadError
  puts 'error swallowed to prevent heroku being mad'
end

task default: %w[hello spec rubocop coverage]

desc 'Say hello!'
task :hello do
  puts "\nHello from Youreul!\n\n"
end

desc 'Check that beautiful coverage.'
task :coverage do
  `open ./coverage/index.html`
end

desc 'Alias for bundle install - currently'
task :build do
  `bundle install`
end

desc 'Run the app'
task :run do
  pid = Process.fork
  if pid.nil?
    # In child
    exec 'redis-server'
  else
    # In parent
    Process.detach(pid)
    `ruby server.rb`
  end
end
