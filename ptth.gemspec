require File.expand_path('../lib/ptth/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "ptth"
  s.version = Ptth::VERSION
  s.authors = ["Zack Reneau-Wedeen", "Mat Brown"]
  s.email = "z.reneau.wedeen@gmail.com"
  s.license = "MIT"
  s.summary = "Lightweight wrapper for major HTTP client libraries"
  s.description = <<DESC
Ptth is a lightweight adapter agnostic wrapper for major HTTP client libraries.
DESC

  s.files = Dir['lib/**/*.rb', 'spec/**/*.rb', 'README.md', 'LICENSE']
  s.has_rdoc = false
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'debugger'
end
