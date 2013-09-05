class Disbursement < ActiveRecord::Base
  include GizmoTransaction
  belongs_to :contact
  belongs_to :disbursement_type
  has_many :gizmo_events, :dependent => :destroy, :autosave => :true
  has_many :gizmo_types, :through => :gizmo_events
  acts_as_userstamp

  validates(:disbursed_at, :disbursement_type_id, :gizmo_events,
            :presence => true)

  validate :validate_inventory_modifications, :associated_contact

  def is_fully_returned?
    gts = {}
    first = self.gizmo_events
    first.each do |x|
      gts[x.gizmo_type_id] ||= 0
      gts[x.gizmo_type_id] += x.gizmo_count
    end
    second = GizmoEvent.find_all_by_return_disbursement_id(self.id)
    second.each do |x|
      gts[x.gizmo_type_id] ||= 0
      gts[x.gizmo_type_id] -= x.gizmo_count
    end
    gts.to_a.select{|k,v|
      v > 0
    }.length == 0
  end

  def gizmo_context
    GizmoContext.disbursement
  end

  before_save :set_occurred_at_on_gizmo_events

  class << self
    def default_sort_sql
      "disbursements.disbursed_at DESC"
    end
  end

  def recipient
    contact
  end

  private
  def associated_contact
    unless is_adjustment?
      errors.add_on_empty("contact_id")
      if contact_id.to_i == 0
        errors.add("contact_id", "does not refer to any single, unique contact")
      end
    end
  end
end
