class KeepOrigLshwXmlToo < ActiveRecord::Migration
  include XmlHelper
  def self.up
    add_column "spec_sheets", :cleaned_output, :text
    add_column "spec_sheets", :original_output, :text
    add_column "spec_sheets", :cleaned_valid, :boolean
    add_column "spec_sheets", :original_valid, :boolean

    ["UPDATE spec_sheets
        SET contact_id=1
        WHERE contact_id IS NULL",
     "ALTER TABLE spec_sheets
        ALTER COLUMN contact_id
        SET NOT NULL",
     "UPDATE spec_sheets
        SET type_id=1
        WHERE type_id IS NULL",
     "ALTER TABLE spec_sheets
        ALTER COLUMN type_id
        SET NOT NULL",
     "UPDATE spec_sheets
        SET action_id=4
        WHERE action_id IS NULL",
     "ALTER TABLE spec_sheets
        ALTER COLUMN action_id
        SET NOT NULL",
     "UPDATE spec_sheets
        SET original_output=lshw_output",
    ].each do |sql|
      puts "executing: #{sql}"
      SpecSheet.connection.execute(sql)
    end

    remove_column "spec_sheets", :lshw_output
    SpecSheet.find(:all).each{|x|
      if x.original_output
        x.lshw_output = x.original_output
        x.save!
      end
    }
  end

  def self.down
    add_column "spec_sheets", :lshw_output, :text
    SpecSheet.connection.execute("UPDATE spec_sheets SET lshw_output=original_output")
    remove_column "spec_sheets", :cleaned_output
    remove_column "spec_sheets", :original_output
    remove_column "spec_sheets", :cleaned_valid
    remove_column "spec_sheets", :original_valid
  end
end
