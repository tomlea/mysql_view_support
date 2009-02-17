class Create<%= class_name.underscore.camelize %>Migration < ActiveRecord::Migration
  def self.up
    update_view :<%= class_name.underscore.pluralize %> do
      select_statement = ""
    end
  end
end
