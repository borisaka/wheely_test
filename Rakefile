require "bundler/gem_tasks"

spec = Gem::Specification.find_by_name 'mongoid'
load "#{spec.gem_dir}/lib/mongoid/tasks/database.rake"

task :environment do
  require 'wheely_test'
end