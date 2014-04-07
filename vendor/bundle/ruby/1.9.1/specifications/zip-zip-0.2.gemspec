# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "zip-zip"
  s.version = "0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Orien Madgwick"]
  s.date = "2013-09-15"
  s.description = "\nIn Gem hell migrating to RubyZip v1.0.0?\nInclude zip-zip in your Gemfile and everything's coming up roses!\n"
  s.email = "orien.madgwick@gmail.com"
  s.homepage = "https://github.com/orien/zip-zip"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.28"
  s.summary = "Ease the migration to RubyZip v1.0.0"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubyzip>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rubyzip>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rubyzip>, [">= 1.0.0"])
  end
end
