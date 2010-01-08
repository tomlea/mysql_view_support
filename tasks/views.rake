unless defined? remove_task
  Rake::TaskManager.class_eval do
    def remove_task(task_name)
      @tasks.delete(task_name.to_s)
    end
  end

  def remove_task(task_name)
    Rake.application.remove_task(task_name)
  end
end

alias drop_database_without_view_support drop_database
def drop_database(config)
  drop_database_without_view_support(config.merge('adapter' => config['adapter'].gsub(/_with_views/, "")))
end

alias create_database_without_view_support create_database
def create_database(config)
  create_database_without_view_support(config.merge('adapter' => config['adapter'].gsub(/_with_views/, "")))
end

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
  namespace :test do
    original_purge_task = Rake::Task["db:test:purge"]
    remove_task "db:test:purge"

    desc "Empty the test database"
    task :purge => :environment do
      abcs = ActiveRecord::Base.configurations
      if abcs["test"]["adapter"] == "mysql_with_views"
        ActiveRecord::Base.establish_connection(:test)
        ActiveRecord::Base.connection.recreate_database(abcs["test"]["database"], abcs["test"])
      else
        original_purge_task.invoke
      end
    end
  end

end

# We need to invoke the db:views:update task IMIDIATELY after the db:migrate task.
# Failure to do so will cause broken schema dumps to happen.
Rake::Task["db:migrate"].actions.unshift lambda{Rake::Task["db:views:update"].invoke}



