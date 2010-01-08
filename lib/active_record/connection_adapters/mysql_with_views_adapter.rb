require_dependency 'active_record/connection_adapters/mysql_adapter'

module ActiveRecord
  class Base
    class << self
      def mysql_with_views_connection(config) # :nodoc:
        ConnectionAdapters::MysqlWithViewsAdapter.new(config)
      end
    end
  end

  class ConnectionAdapters::MysqlWithViewsAdapter < DelegateClass(ActiveRecord::ConnectionAdapters::MysqlAdapter)
    attr_reader :view_options
    def initialize(config)
      super ActiveRecord::Base.mysql_connection(config)
      @view_options = (config.symbolize_keys[:view_options] || {}).symbolize_keys.freeze
    end

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

    def views(name = nil) #:nodoc:
      tables = []
      result = execute("SHOW FULL TABLES", name)
      result.each { |field| tables << field[0] if field[1] == 'VIEW' }
      result.free
      tables
    end

    def pk_and_sequence_for(table)
      if table_key = super(table)
        table_key
      elsif views.include?( table.to_s ) and columns(table).any?{|col| col.name == 'id'}
        view_key = ['id', nil]
      end
    end

  end
end
