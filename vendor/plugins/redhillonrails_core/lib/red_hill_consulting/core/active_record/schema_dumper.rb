module RedHillConsulting::Core::ActiveRecord
  module SchemaDumper
    def self.included(base)
      base.class_eval do
        private
        alias_method_chain :tables, :redhillonrails_core
        alias_method_chain :indexes, :redhillonrails_core
        alias_method_chain :tables, :railspgprocs
        alias_method_chain :indexes, :railspgprocs
      end
    end

    private

    def tables_with_redhillonrails_core(stream)
      @foreign_keys = StringIO.new
      begin
        tables_without_redhillonrails_core(stream)
        @foreign_keys.rewind
        stream.print @foreign_keys.read
      ensure
        @foreign_keys = nil
      end
    end

    def tables_with_railspgprocs(stream)
      #added for railspgprocs
      if defined?(types)
        types(stream)
      end
      #added for railspgprocs
      if defined?(procedures)
        procedures(stream, "!= 'sql'")
      end
      tables_without_railspgprocs(stream)
      #added for railspgprocs
      if defined?(procedures)
        procedures(stream, "= 'sql'")
      end
    end

    def indexes_with_redhillonrails_core(table, stream)
      indexes = @connection.indexes(table)
      indexes.each do |index|
        stream.print "  add_index #{index.table.inspect}, #{index.columns.inspect}, :name => #{index.name.inspect}"
        stream.print ", :unique => true" if index.unique
        stream.print ", :case_sensitive => false" unless index.case_sensitive?
        stream.puts
      end
      stream.puts unless indexes.empty?

      foreign_keys(table, @foreign_keys)
    end

    def indexes_with_railspgprocs(table, stream)
      indexes_without_railspgprocs(table, stream)
      #added for railspgprocs
      if defined?(triggers)
        triggers(table, stream)
      end
    end

    def foreign_keys(table, stream)
      foreign_keys = @connection.foreign_keys(table)
      foreign_keys.each do |foreign_key|
        stream.print "  "
        stream.print foreign_key.to_dump
        stream.puts
      end
      stream.puts unless foreign_keys.empty?
    end
  end
end
