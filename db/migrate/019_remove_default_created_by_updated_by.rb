class RemoveDefaultCreatedByUpdatedBy < ActiveRecord::Migration
  def self.up
    conn = User.connection
    conn.tables.each do |table|
      next if table == 'user'
      conn.columns(table).map{|x| x.name}.select do |col|
        col == 'created_by' or col == 'updated_by'
        end.each do |col|
        if table == 'sales' or table == 'donations'
          conn.execute("ALTER TABLE #{table} ALTER #{col} DROP DEFAULT")
          conn.execute("ALTER TABLE #{table} ALTER #{col} DROP NOT NULL") if col == 'updated_by'
        else 
          remove_column table, col
        end
      end
    end
  end

  def self.down
    conn = User.connection
    conn.tables.each do |table|
      next if table == 'roles' or table == 'sales' or table == 'donations'
      conn.columns(table).map{|x| x.name}.select do |col|
        col == 'created_at' or col == 'updated_at'
      end.each do |col|
        add_column table, col.sub(/_at$/, "_by"), :bigint, :null=>false, :default=>1
      end
    end

    ["sales", "donations"].each do |table|
      ["updated_by", "created_by"].each do |col|
        conn.execute("ALTER TABLE #{table} ALTER #{col} DROP DEFAULT")
        conn.execute("ALTER TABLE #{table} ALTER #{col} DROP NOT NULL") if col == 'updated_by'
      end
    end

    add_column "roles", :created_by, :bigint
    add_column "roles", :updated_by, :bigint
  end
end
