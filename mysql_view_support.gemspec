# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mysql_view_support}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Lea"]
  s.date = %q{2009-05-13}
  s.email = %q{contrib@tomlea.co.uk}
  s.files = ["tasks/views.rake", "generators/sql_view_migration", "generators/sql_view_migration/sql_view_migration_generator.rb", "generators/sql_view_migration/templates", "generators/sql_view_migration/templates/migration.rb", "rails/init.rb"]
  s.homepage = %q{http://labs.reevoo.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Provides view creation support to rails.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
