
ActiveRecord::ConnectionAdapters::MysqlAdapter.class_eval do
  def create_view(name, column_names = nil, options = {})
    raise ArgumentError, "You must provide the SQL statement that defines the view." unless block_given?
    select_statement = yield
    command = ["CREATE"]
    command << "OR REPLACE" if options[:force]
    command << "VIEW #{quote_table_name(name)}"
    command << "(" + [column_names].flatten.join(", ") + ")" if column_names
    command << "AS #{select_statement}"
    execute command.join(" ")
  end

  def update_view(name, column_names = nil, options = {}, &block)
    create_view name, column_names, options.merge(:force => true), &block
  end

  def drop_view(name)
    execute "DROP VIEW #{quote_table_name(name)}"
  end

private
  def view_options
    @config[:view_options].symbolize_keys || {}
  end
end
