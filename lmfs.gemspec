# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Lmfs/version'

Gem::Specification.new do |spec|
  spec.name          = 'lmfs'
  spec.version       = Lmfs::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ['Matt J. Wiater']
  spec.email         = ['matt.wiater@roundhouseagency.com']

  spec.summary       = 'Simple local file storage.'
  spec.description   = 'Msgpack + Pstore = Lmfs'
  spec.homepage      = 'https://github.com/mwiater/lmfs'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  #spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         = ["lib/Lmfs.rb"]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency     'msgpack',            '~> 1.0'

  spec.add_development_dependency 'bundler',            '~> 1.8'
  spec.add_development_dependency 'rake',               '~> 10.0'
  spec.add_development_dependency 'minitest',           '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'yard',               '~> 0.9'
  spec.add_development_dependency 'rubocop',            '~> 0.42'
end
