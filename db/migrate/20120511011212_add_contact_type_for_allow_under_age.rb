class AddContactTypeForAllowUnderAge < ActiveRecord::Migration
  def self.up
    return unless Default.is_pdx
    ct = ContactType.new
    ct.for_who = 'per'
    ct.description = 'allow w/out adult'
    ct.name = 'allow_without_adult'
    ct.save!
  end

  def self.down
    ContactType.find_by_name('allow_without_adult').destroy
  end
end
