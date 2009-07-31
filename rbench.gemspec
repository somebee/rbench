GEM = "rbench"
VERSION = "0.2.4"
AUTHOR = "Yehuda Katz & Sindre Aarsaether"
EMAIL = "sindre [a] identu [d] no" # doesnt actually go anywhere atm..
HOMEPAGE = "http://www.github.com/somebee/rbench"
SUMMARY = "Library for generating nice ruby-benchmarks"

RDOC_FILES = %w[ README LICENSE TODO ]
SPEC_FILES = %w[ rbench_spec.rb spec.opts spec_helper.rb ].map{|f| "spec/"+f}
LIB_FILES =  %w[ .rb /summary.rb /runner.rb /report.rb /group.rb /column.rb].map{|f| "lib/rbench"+f}
PACKAGE_FILES = RDOC_FILES + SPEC_FILES + LIB_FILES

puts PACKAGE_FILES.inspect

GEMSPEC = Gem::Specification.new do |s|
  s.name = GEM
  s.version = VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = RDOC_FILES
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = PACKAGE_FILES
end
