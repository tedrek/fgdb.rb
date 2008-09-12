class KeepOrigLshwXmlToo < ActiveRecord::Migration
  include XmlHelper
  def self.up
    add_column "spec_sheets", :cleaned_output, :text
    add_column "spec_sheets", :original_output, :text
    add_column "spec_sheets", :cleaned_valid, :boolean
    add_column "spec_sheets", :original_valid, :boolean
    SpecSheet.connection.execute("UPDATE spec_sheets SET original_output=lshw_output")
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
