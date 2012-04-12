class DisciplinaryAction < ActiveRecord::Base
  has_and_belongs_to_many :disciplinary_action_areas
  belongs_to :contact
  named_scope :not_disabled, :conditions => ["disabled = 'f'"]
end
