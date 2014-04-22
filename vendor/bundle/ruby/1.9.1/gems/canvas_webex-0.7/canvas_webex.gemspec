# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canvas_webex/version'

Gem::Specification.new do |gem|
  gem.name          = 'canvas_webex'
  gem.version       = CanvasWebex::VERSION
  gem.authors       = ['Nathan Mills']
  gem.email         = ['nathanm@instructure.com']
  gem.description   = %q{Canvas WebEx is an Cisco Webex plugin for the Instructure Canvas LMS. It allows teachers and administrators to create and launch WEbEx conferences directly from their courses.}
  gem.summary       = %q{Cisco WebEx integration for Instructure Canvas (http://instructure.com).}
  gem.homepage      = 'http://instructure.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w{app lib}

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'nokogiri'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'pry'
end

