require File.expand_path("../lib/bitpagos/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bitpagos"
  s.version     = Bitpagos::VERSION
  s.date        = "2015-12-24"
  s.summary     = "Bitpagos payment processing"
  s.description = "Ruby wrapper for the Bitpagos payment processing API"
  s.authors     = ["Mauro Otonelli", "Ernesto Tagwerker"]
  s.email       = "hola@ombulabs.com"
  s.files       = Dir["lib/**/**.rb"]
  s.homepage    = "http://github.com/ombulabs/bitpagos"
  s.license       = "MIT"
end
