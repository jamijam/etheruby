Gem::Specification.new do |s|
  s.name = 'etheruby'
  s.version = '0.9.0'
  s.date = '2017-01-19'
  s.summary = 'Etheruby : The Ethereum Object-Contract Mapper (OCM) for Ruby.'
  s.description = 'Etheruby is a library including a client for the JSON-RPC API and a Object-Contract Mapper to interact with smart-contracts.'
  s.authors = ['Jérémy SEBAN']
  s.email = 'jeremy@seban.eu'
  s.files = Dir['lib/**/*']
  s.license = 'MIT'
  s.homepage = 'https://github.com/MechanicalSloth/etheruby'
  s.add_development_dependency 'digest-sha3', '~> 1.1'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_runtime_dependency 'multi_json', '~> 1.12'
  s.add_runtime_dependency 'digest-sha3', '~> 1.1'
  s.required_ruby_version = '~> 2.3'
end
