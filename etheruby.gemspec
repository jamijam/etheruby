Gem::Specification.new do |s|
  s.name = 'etheruby'
  s.version = '0.0.2'
  s.date = '2017-01-16'
  s.summary = 'Etheruby : Ethereum smart-contract classy-describer for Ruby.'
  s.description = 'Describe ethereum smart-contract and execute them with ease.'
  s.authors = ['Jérémy SEBAN']
  s.email = 'jeremy@seban.eu'
  s.files = Dir['lib/**/*']
  s.license = 'MIT'
  s.homepage = 'https://github.com/MechanicalSloth/etheruby'
  s.add_development_dependency 'digest-sha3', '~> 1.1'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_runtime_dependency 'multi_json', '~> 1.12'
  s.add_runtime_dependency 'rspec', '~> 3.5'
  s.required_ruby_version = '~> 2.3'
end
