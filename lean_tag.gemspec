$:.push File.expand_path("../lib", __FILE__)

require 'lean_tag/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lean_tag"
  s.version     = LeanTag::VERSION
  s.authors     = ["Matt Ellis"]
  s.email       = ["m.ellis27@gmail.com"]
  s.homepage    = "https://github.com/waffleau/lean_tag"
  s.summary     = "A lightweight method for tagging content"
  s.description = "And simple and clean implementation of content tagging for Rails 4 and above"
  s.license     = "MIT"

  s.files = Dir["{db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "rspec"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "sqlite3"

  s.add_runtime_dependency 'activerecord', '>= 4.0'
end
