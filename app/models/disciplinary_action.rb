class DisciplinaryAction < ActiveRecord::Base
  acts_as_userstamp
  def self.cashierable
    true
  end
  has_and_belongs_to_many :disciplinary_action_areas
  belongs_to :contact
  scope :not_disabled, where(:disabled => false)
end
