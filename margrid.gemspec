# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'margrid/version'

Gem::Specification.new do |spec|
  spec.name          = "margrid"
  spec.version       = Margrid::VERSION
  spec.authors       = ["Yves Senn", "Jonas Baumann"]
  spec.email         = ["yves.senn@gmail.com"]
  spec.summary       = %q{Grid library to build paginated and sortable tables.}
  spec.description   = %q{Margrid makes it easy to add sortable and paginated tables to your web pages. Since state is passed through the query string, browser bookmarks can be used to save different views.}
  spec.homepage      = "https://www.github.com/4teamwork/margrid"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.4"
end
