require "rubygems"
require "rake/gempackagetask"

task :default => :package

spec = Gem::Specification.new do |s|
  s.name              = "mysql_view_support"
  s.version           = "0.2.0"
  s.summary           = "Provides view support to rails."
  s.author            = "Tom Lea"
  s.email             = "contrib@tomlea.co.uk"
  s.homepage          = "http://labs.reevoo.com"

  s.has_rdoc          = false

  s.files             = Dir.glob("{tasks,generators,lib}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Clear out generated packages'
task :clean => [:clobber_package]
