$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "riews/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "riews"
  s.version     = Riews::VERSION
  s.authors     = ["Manuel Bustillo"]
  s.email       = ["mayn13@gmail.com"]
  s.homepage    = "https://github.com/bustikiller/riews"
  s.summary     = "A Drupal-like customizable views engine"
  s.description = "A Drupal-like customizable views engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.0.0"
  s.add_dependency "cocoon", "1.2.11"
  s.add_dependency "kaminari", "1.1.1"
  s.add_dependency "dentaku", ">= 3.2", "< 3.5"
  s.add_dependency "bh", "~>1.3.6"
  s.add_dependency "btgen", "~>0.1.1"
  s.add_dependency "simple_form", "~>3.5.0"
  s.add_dependency "rails_bootstrap_navbar", "~> 3.0.0"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
