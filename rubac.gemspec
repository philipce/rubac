$: << File.expand_path('../lib', __FILE__)
require 'rubac/version'

Gem::Specification.new do |s|
  s.name = "rubac"
  s.version = Rubac::VERSION
  s.authors = ["Aaron Wood", "Philip Erickson"]
  s.summary = "Role-based access control for Ruby"
  s.homepage = "https://github.com/philipce/rubac"
  s.files = ["lib/rubac.rb"]
  s.require_paths = ["lib"]
end
