class Recycling < ActiveRecord::Base
  include GizmoTransaction
  belongs_to :contact, :order => "surname, first_name"  
  has_many :gizmo_events, :dependent => :destroy

  def validate
    errors.add_on_empty("contact_id")
    errors.add_on_empty("gizmo_events")
  end
end
