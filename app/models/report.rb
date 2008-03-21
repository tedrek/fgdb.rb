class Report < ActiveRecord::Base
  belongs_to :contact
  belongs_to :role
  belongs_to :system
  belongs_to :type

  def type_id=(type)
    write_attribute(:type_id, Type.find_by_name(type).id)
  end
  def role_id=(role)
    write_attribute(:role_id, Role.find_by_name(role).id)
  end
  def my_file=(file)
      write_attribute(:lshw_output, file.read)
  end
  def my_file
    nil
  end
end
