namespace :db do
  namespace :views do
    desc "Run views migration from db/views"
    task :update => :environment do
      view_migration_classes = Dir.glob(File.join(Rails.root, "db", "views", "*.rb")).map{|view_migration|
        if File.basename(view_migration) =~ /[0-9]+_([^.]+).rb/
          require view_migration
          view_migration_class = "create_#{$1}_migration".camelize.constantize
        end
      }

      view_migration_classes.each{|mc|
        mc.migrate(:up)
      }
    end
  end
end

Rake::Task["db:migrate"].enhance do
 Rake::Task["db:views:update"].invoke
end
