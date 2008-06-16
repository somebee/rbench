require 'pathname'

GEM = "rbench"
VERSION = "0.2"
AUTHOR = "Yehuda Katz & Sindre Aarsaether"
EMAIL = "post [a] rbench [d] org" # doesnt actually go anywhere atm..
HOMEPAGE = "http://www.rbench.org"
SUMMARY = "Library for generating nice ruby-benchmarks"

PACKAGE_FILES = [
  'README',
  'LICENSE',
  '*.rb',
  'lib/**/*.rb',
  'spec/**/*.rb'
].collect { |pattern| Pathname.glob(pattern) }.flatten.map{|p| p.to_s}

puts PACKAGE_FILES.inspect

GEMSPEC = Gem::Specification.new do |s|
  s.name = GEM
  s.version = VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = %w[ README LICENSE TODO ]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = PACKAGE_FILES
end
