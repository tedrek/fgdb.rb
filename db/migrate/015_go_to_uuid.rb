class GoToUuid < ActiveRecord::Migration
  def self.up
    conn = Contact.connection
    conn.tables.each {|table|
      this = table
      key = eval(Inflector.classify(table)).primary_key
      add_column(this, 'temporary_id_field')
      conn.execute "UPDATE #{this} SET temporary_id_field = '#{this[-20..-1]}' || #{key}"
    }
    fkeys = []
    conn.tables.each {|table|
      table = eval(Inflector.classify(table))
      this = table.table_name
      key = table.primary_key
      table.foreign_keys.each {|ref|
        that = ref.references_table_name
        fkey = ref.references_column_names[0]
        fkeys << [that,fkey,this,key]
        add_column(that, 'temporary_fk_field')
        conn.execute "UPDATE #{that} SET temporary_fk_field =
          (SELECT #{this}.temporary_id_field from #{this} where #{this}.#{key} = #{that}.#{fkey})"
        drop_column(that, fkey) # to kill the constraints
        rename_column(that, 'temporary_fk_field', fkey)
      }
      conn.execute "ALTER TABLE #{this} drop constraint #{this}_pkey"
      drop_column(this, key)
      rename_column(this, 'temporary_id_field', key)
      conn.execute "ALTER TABLE #{this} add constraint #{this}_pkey PRIMARY KEY (#{key})"
    }
    fkeys.each {|that,fkey,this,key|
      add_foreign_key(that, [fkey], this, [key], :name => "#{that}_#{this}_fk")
    }
  end

  def self.down
    # gah!
  end
end
