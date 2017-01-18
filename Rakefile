require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

RSpec::Core::RakeTask.new('encoders') do |t|
  t.pattern = [
    'spec/encoders/*.rb'
  ]
end

task default: [:spec, :build]
task test: :spec
