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

# We need to invoke the db:views:update task IMIDIATELY after the db:migrate task.
# Failure to do so will cause broken schema dumps to happen.
Rake::Task["db:migrate"].actions.unshift lambda{Rake::Task["db:views:update"].invoke}
