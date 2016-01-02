require File.expand_path("../lib/bitpagos/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bitpagos"
  s.version     = Bitpagos::VERSION
  s.date        = "2015-12-31"
  s.summary     = "Bitpagos payment processing"
  s.description = "Ruby wrapper for the Bitpagos payment processing API"
  s.authors     = ["Mauro Otonelli", "Ernesto Tagwerker"]
  s.email       = "hola@ombulabs.com"
  s.files       = Dir["lib/**/**.rb"]
  s.homepage    = "http://github.com/ombulabs/bitpagos"
  s.license     = "MIT"

  s.add_dependency("rest-client", "~> 1.8")
  s.add_development_dependency("rspec", "~> 3.3")
  s.add_development_dependency("rake", "~> 10.4")
  s.add_development_dependency("pry-byebug", "~> 3.2")
  s.add_development_dependency("webmock", "~> 1.21")
  s.add_development_dependency("vcr", "~> 2.9")
end
