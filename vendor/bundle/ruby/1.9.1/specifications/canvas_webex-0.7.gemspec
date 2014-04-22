# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "canvas_webex"
  s.version = "0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Mills"]
  s.date = "2013-11-21"
  s.description = "Canvas WebEx is an Cisco Webex plugin for the Instructure Canvas LMS. It allows teachers and administrators to create and launch WEbEx conferences directly from their courses."
  s.email = ["nathanm@instructure.com"]
  s.homepage = "http://instructure.com"
  s.require_paths = ["app", "lib"]
  s.rubygems_version = "1.8.28"
  s.summary = "Cisco WebEx integration for Instructure Canvas (http://instructure.com)."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
