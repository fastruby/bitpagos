require 'rspec/core/rake_task'
require File.expand_path("../lib/bitpagos/version", __FILE__)

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color']
end

task default: :spec

task :build do
  sh "gem build bitpagos.gemspec"
end

task release: :build do
  sh "git push origin master"
  sh "gem push bitpagos-#{Bitpagos::VERSION}.gem"
end

task :console do
  sh "irb -rubygems -I lib -r bitpagos.rb"
end

