class Disbursement < ActiveRecord::Base

  include GizmoTransaction
  belongs_to :contact, :order => "surname, first_name"
  belongs_to :disbursement_type
  has_many :gizmo_events, :dependent => :destroy

  def validate
    errors.add_on_empty("contact_id")
    errors.add_on_empty("disbursed_at", "when?")
    errors.add_on_empty("disbursement_type_id")
    errors.add_on_empty("gizmo_events")
  end

  def recipient
    contact.display_name
  end
end
