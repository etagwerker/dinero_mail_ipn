# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dinero_mail_ipn/version"

Gem::Specification.new do |s|
  s.name        = "dinero_mail_ipn"
  s.version     = DineroMailIpn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ernesto Tagwerker", "Esteban Pastorino"]
  s.email       = ["ernesto@etagwerker.com", "kito@pinggers.com"]
  s.homepage    = ""
  s.summary     = %q{Dinero Mail IPN gem}
  s.description = %q{Dinero Mail IPN stub}

  s.rubyforge_project = "dinero_mail_ipn"

  s.add_dependency 'httparty', '~> 0.7.6'
  s.add_dependency 'nokogiri', '~> 1.4.4'


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
