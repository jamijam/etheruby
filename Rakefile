require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

RSpec::Core::RakeTask.new('integration') do |t|
  t.pattern = [
    'spec/integration/*.rb'
  ]
end

RSpec::Core::RakeTask.new('unit') do |t|
  t.pattern = [
    'spec/unit/*.rb'
  ]
end

task default: [:spec, :build]
task test: :spec
