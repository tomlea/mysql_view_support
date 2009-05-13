require "rubygems"
require "rake/gempackagetask"

task :default => :package do
  puts "Don't forget to write some tests!"
end

spec = Gem::Specification.new do |s|
  s.name              = "mysql_view_support"
  s.version           = "0.1.0"
  s.summary           = "Provides view creation support to rails."
  s.author            = "Tom Lea"
  s.email             = "contrib@tomlea.co.uk"
  s.homepage          = "http://labs.reevoo.com"

  s.has_rdoc          = false

  s.files             = %w(init.rb) + Dir.glob("{tasks,generators}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec

  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

desc 'Clear out generated packages'
task :clean => [:clobber_package] do
  rm "#{spec.name}.gemspec"
end
