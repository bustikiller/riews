$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "riews/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "riews"
  s.version     = Riews::VERSION
  s.authors     = ["Manuel Bustillo"]
  s.email       = ["mayn13@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Riews."
  s.description = "TODO: Description of Riews."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.2"

  s.add_development_dependency "sqlite3"
end
