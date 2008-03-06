class AddCustomizations < ActiveRecord::Migration
  def self.up
    create_table "customizations", :force => true do |t|
      t.column "key",   :string
      t.column "value", :string
    end
    execute 'COMMENT ON TABLE customizations IS \'Configuration settings that will likely vary from installation to installation.\' '
    execute 'INSERT INTO customizations (key, value) VALUES (\'time_resolution\', \'15\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'day_start_display\', \'09:00\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'day_end_display\', \'17:00\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'hour_format\', \'12\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'week_start\', \'Sun\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'display_start\', \'today\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'display_length\', \'7\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'generate_start_day\', \'Sun\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'generate_start_week\', \'1\')'
    execute 'INSERT INTO customizations (key, value) VALUES (\'generate_length\', \'14\')'
  end

  def self.down
    drop_table "customizations"
  end
end
