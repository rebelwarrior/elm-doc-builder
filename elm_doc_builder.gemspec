
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'edb/version'

Gem::Specification.new do |spec|
  spec.name          = 'elm_doc_builder'
  spec.version       = EDB::VERSION
  spec.authors       = ['rebelwarrior']
  spec.email         = ['rabbit.editor@yahoo.com']

  spec.summary       = 'Elm Document Builder'
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(/^(assets|_layouts|_includes|LICENSE|README)/i) }

  spec.required_ruby_version = '>= 2.3.3'

  spec.metadata["yard.run"] = "yri" # use "yard" to build full HTML docs.

  spec.add_runtime_dependency 'pry', '~> 0.11.3'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 12.3'

  spec.add_development_dependency 'minitest', '~> 5.11'
  # spec.add_development_dependency 'rubocop', '~> 0.52', '>= 0.52.1'
end