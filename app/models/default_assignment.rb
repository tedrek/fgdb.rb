class DefaultAssignment < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_default_shift
end
