class KeepOrigLshwXmlToo < ActiveRecord::Migration
  include XmlHelper
  def self.up
    add_column "spec_sheets", :cleaned_output, :text
    add_column "spec_sheets", :original_output, :text
    add_column "spec_sheets", :cleaned_valid, :boolean
    add_column "spec_sheets", :original_valid, :boolean
    SpecSheet.connection.execute("UPDATE spec_sheets SET original_output=lshw_output")
    SpecSheet.connection.execute("UPDATE spec_sheets SET cleaned_output=lshw_output")
    SpecSheet.find(:all).each{|x|
      x.original_valid = (load_xml(x.original_output) ? true : false) # SLOW!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      x.save
    }
    SpecSheet.connection.execute("UPDATE spec_sheets SET cleaned_valid=original_valid") # original and cleaned are the same, don't waste all of the time needed to load all of that xml again
    remove_column "spec_sheets", :lshw_output
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
