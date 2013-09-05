class GizmoReturn < ActiveRecord::Base
  define_amount_methods_on("storecredit_difference")
  has_many :gizmo_events, :dependent => :destroy, :autosave => :true
  has_many :gizmo_types, :through => :gizmo_events
  include GizmoTransaction
  belongs_to :contact
  has_one :store_credit, :autosave => :true
  before_save :set_storecredit_difference_cents
  before_save :set_occurred_at_on_gizmo_events
  define_amount_methods_on("storecredit_difference")
  acts_as_userstamp
  before_save :set_occurred_at_on_transaction

  validate(:validate_inventory_modifications, :named_contact,
           :has_gizmos, :store_credit_privileges)
  attr_accessor :contact_type  #anonymous or named
  before_save :strip_postal_code
  before_save :unzero_contact_id
  def contact_type
    @contact_type ||= contact ? 'named' : 'anonymous'
  end

  def initialize(*args)
    @contact_type = 'anonymous'
    super(*args)
  end

  def storecredit_spent
    self.store_credit.spent?
  end

  def storecredits
    self.store_credit ? [self.store_credit] : []
  end

  def self.default_sort_sql
    "gizmo_returns.created_at DESC"
  end

  def gizmo_context
    GizmoContext.gizmo_return
  end

  def editable
    !(store_credit && store_credit.spent?)
  end

  def store_credit_id
    self.store_credit.id
  end

  def store_credit_hash
    self.store_credit.store_credit_hash
  end

  def set_storecredit_difference_cents
    self.storecredit_difference_cents = calculated_subtotal_cents
    if self.storecredit_difference_cents != 0
      self.store_credit ||= StoreCredit.new
      self.store_credit.amount_cents = self.storecredit_difference_cents
      self.store_credit.expire_date ||= (Date.today + StoreCredit.expire_after_value)
    else
      self.store_credit.destroy if self.store_credit
      self.store_credit = nil
    end
  end

  def link_text
    self.created_at.strftime("%m/%d/%Y") + " (" + self.gizmos + ", $" + self.storecredit_difference + ")"
  end

  private
  def named_contact
    if contact_type == 'named'
      errors.add_on_empty("contact_id")
      if contact_id.to_i == 0 or !Contact.exists?(contact_id)
        errors.add("contact_id",
                   "does not refer to any single, unique contact")
      end
    else
      errors.add_on_empty("postal_code")
    end
  end

  def has_gizmos
    if gizmo_events_actual.empty?
      errors.add("gizmos", "should include something")
    end
  end

  def store_credit_privileges
    if (self.store_credit and
        self.store_credit.amount_cents_changed? and
        self.store_credit.amount_cents > 0)
      storecredit_priv_check
    end
  end
end
