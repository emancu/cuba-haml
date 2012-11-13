Gem::Specification.new do |s|
  s.name              = "cuba-haml"
  s.version           = "1.0"
  s.summary           = "A Cuba plugin to use Haml."
  s.description       = "Cuba is a microframework for web applications."
  s.authors           = ["Emiliano Mancuso"]
  s.email             = ["emiliano.mancuso@gmail.com"]
  s.homepage          = "http://github.com/eMancu/cuba-haml"
  s.license           = "UNLICENSE"

  s.files = Dir[
    "README.md",
    "Rakefile",
    "lib/**/*.rb",
    "*.gemspec",
    "test/*.*"
  ]

  s.add_dependency "cuba"
  s.add_dependency "haml"
  s.add_development_dependency "cutest"
  s.add_development_dependency "rack-test"
end
