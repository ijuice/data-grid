$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "grid/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "grid"
  s.version     = Grid::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "http://ijuice.de"
  s.summary     = "Displays Data"
  s.description = "Displays Data in ActiveRecords as Table"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
