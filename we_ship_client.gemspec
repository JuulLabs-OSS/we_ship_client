require_relative 'lib/we_ship_client/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.0'
  spec.name          = 'we_ship_client'
  spec.version       = WeShipClient::VERSION
  spec.authors       = ['Juul Labs, Inc.']
  spec.email         = ['opensource@juul.com']

  spec.summary       = "API client for We Ship Express V2."
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/JuulLabs-OSS/we_ship_client'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'dry-struct', '~> 1.4'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'loogi_http', '~> 1.0'

  spec.add_development_dependency 'stub_env'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
