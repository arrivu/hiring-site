# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "subdomain-fu"
  s.version = "0.5.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh"]
  s.date = "2010-01-18"
  s.description = "SubdomainFu is a Rails plugin to provide all of the basic functionality necessary to handle multiple subdomain applications (such as Basecamp-esque subdomain accounts and more)."
  s.email = "michael@intridea.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/mbleigh/subdomain-fu"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "subdomain-fu"
  s.rubygems_version = "1.8.28"
  s.summary = "SubdomainFu is a Rails plugin that provides subdomain routing and URL writing helpers."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
