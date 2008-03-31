class Report < ActiveRecord::Base
  include ReportsHelper

  belongs_to :contact
  belongs_to :role
  belongs_to :system
  belongs_to :type

  def my_file=(file)
      write_attribute(:lshw_output, file.read)
  end
  def my_file
    nil
  end
end
