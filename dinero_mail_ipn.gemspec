# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dinero_mail_ipn/version"

Gem::Specification.new do |s|
  s.name        = "dinero_mail_ipn"
  s.version     = DineroMailIpn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ernesto Tagwerker", "Esteban Pastorino"]
  s.email       = ["ernesto@ombushop.com", "kito@pinggers.com"]
  s.homepage    = ""
  s.summary     = %q{Dinero Mail IPN gem}
  s.description = %q{Dinero Mail IPN stub}

  s.rubyforge_project = "dinero_mail_ipn"

  s.add_dependency 'httparty', '~> 0.8.1'
  s.add_dependency 'nokogiri', '~> 1.5.0'
  s.add_dependency 'chronic', '~> 0.10.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files = [
    "test/helper.rb",
     "test/test_dinero_mail_ipn.rb"
  ]
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'shoulda', '~> 2.11.3'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'
  s.add_development_dependency 'yard', '~> 0.7.4'
  s.add_development_dependency 'redcarpet', '~> 2.0.1'
  s.add_development_dependency 'rake'

  if RUBY_VERSION > "1.9.3"
    s.add_development_dependency 'byebug'
  end
end
