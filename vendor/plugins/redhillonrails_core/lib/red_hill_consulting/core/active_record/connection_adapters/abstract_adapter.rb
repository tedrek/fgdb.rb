module RedHillConsulting::Core::ActiveRecord::ConnectionAdapters
  module AbstractAdapter
    def self.included(base)
      base.module_eval do
        alias_method_chain :drop_table, :redhillonrails_core
      end
    end

    def foreign_keys(table_name, name = nil)
      []
    end

    def reverse_foreign_keys(table_name, name = nil)
      []
    end

    def add_foreign_key(table_name, column_names, references_table_name, references_column_names, options = {})
      if options[:on_delete] == :set_null
        execute "UPDATE #{table_name} SET #{column_names[0]} = NULL WHERE #{column_names[0]} IS NOT NULL AND NOT EXISTS (SELECT * FROM #{references_table_name} as rtn WHERE rtn.#{references_column_names[0]} = #{table_name}.#{column_names[0]})" 
      elsif options[:on_delete] == :set_default
        execute "UPDATE #{table_name} SET #{column_names[0]} = DEFAULT WHERE #{column_names[0]} IS NOT NULL AND NOT EXISTS (SELECT * FROM #{references_table_name} as rtn WHERE rtn.#{references_column_names[0]} = #{table_name}.#{column_names[0]})"
      elsif options[:on_delete] == :restrict
        i = 0
        execute("SELECT * FROM #{table_name} WHERE #{column_names[0]} IS NOT NULL AND NOT EXISTS (SELECT * FROM #{references_table_name} as rtn WHERE rtn.#{references_column_names[0]} = #{table_name}.#{column_names[0]})").each{|x| i += 1}
        if i > 0
          raise
        end
      else #default behavior...do this for no action and cascade
      	execute "DELETE FROM #{table_name} WHERE #{column_names[0]} IS NOT NULL AND NOT EXISTS (SELECT * FROM #{references_table_name} as rtn WHERE rtn.#{references_column_names[0]} = #{table_name}.#{column_names[0]})"
      end
      foreign_key = ForeignKeyDefinition.new(options[:name], table_name, column_names, ActiveRecord::Migrator.proper_table_name(references_table_name), references_column_names, options[:on_update], options[:on_delete], options[:deferrable])
      execute "ALTER TABLE #{table_name} ADD #{foreign_key}"
    end

    def remove_foreign_key(table_name, foreign_key_name)
      execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{foreign_key_name}"
    end

    def drop_table_with_redhillonrails_core(name, options = {})
      reverse_foreign_keys(name).each { |foreign_key| remove_foreign_key(foreign_key.table_name, foreign_key.name) }
      drop_table_without_redhillonrails_core(name, options)
    end
  end
end
