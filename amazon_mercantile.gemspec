# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amazon_mercantile/version'

Gem::Specification.new do |spec|
  spec.name          = 'amazon_mercantile'
  spec.version       = AmazonMercantile::VERSION
  spec.authors       = ['James Thompson']
  spec.email         = %w{jamest@plainprograms.com}
  spec.description   = %q{A working library to work with Amazon's Marketplace Web Service (MWS).}
  spec.summary       = %q{Amazon Marketplace Web Service (MWS) library}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
