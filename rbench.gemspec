GEM = "rbench"
VERSION = "0.2"
AUTHOR = "Yehuda Katz & Sindre Aarsaether"
EMAIL = "post [a] rbench [d] org" # doesnt actually go anywhere atm..
HOMEPAGE = "http://www.rbench.org"
SUMMARY = "Library for generating nice ruby-benchmarks"

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
  s.files = FileList['LICENSE','README','Rakefile','lib/**/*.rb','spec/*']
end
