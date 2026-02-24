require "sinatra/activerecord/rake"

task default: %w[run]

desc "run the app with rerun"
task :dev do
  ruby "./app.rb"
end

namespace :db do
  task :load_config do
    require "./app"
  end
end
