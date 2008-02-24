class Donation < ActiveRecord::Base
  acts_as_userstamp

  include GizmoTransaction
  belongs_to :contact, :order => "surname, first_name"
  has_many :payments, :dependent => :destroy
  has_many :gizmo_events, :dependent => :destroy

  before_save :add_contact_types

  def initialize(*args)
    super(*args)
  end

  attr_writer :contact_type #anonymous, named, or dumped

  def validate
    if contact_type == 'named'
      errors.add_on_empty("contact_id")
    elsif contact_type == 'anonymous'
      errors.add_on_empty("postal_code")
    end
    gizmo_events.each do |gizmo|
       errors.add("gizmos", "must have positive quantity") unless gizmo.valid_gizmo_count?
    end
    errors.add("payments", "are too little to cover required fees") unless(invoiced? or required_paid? or contact_type == 'dumped')
    errors.add("payments", "or gizmos should include some reason to call this a donation") if
      gizmo_events.empty? and payments.empty?
    errors.add("payments", "may only have one invoice") if invoices.length > 1
  end

  def donor
    if contact_type == 'named'
      contact
    elsif contact_type == 'anonymous'
      "anonymous(#{postal_code})"
    else
      'dumped'
    end
  end

  def contact_type
    unless @contact_type
      if contact
        @contact_type = 'named'
      elsif postal_code != '' and not postal_code.nil?
        @contact_type = 'anonymous'
      elsif id
        @contact_type = 'dumped'
      else
        @contact_type = 'named'
      end
    end
    @contact_type
  end

  def required_contact_type
    ContactType.find(7)
  end

  def reported_total
    reported_required_fee + reported_suggested_fee
  end

  def calculated_required_fee
    gizmo_events.inject(0.0) {|total, gizmo|
      next if gizmo.mostly_empty?
      total + gizmo.required_fee
    }
  end

  def calculated_suggested_fee
    gizmo_events.inject(0.0) {|total, gizmo|
      total + gizmo.suggested_fee
    }
  end

  def calculated_total
    calculated_suggested_fee + calculated_required_fee
  end

  def cash_donation_owed
    [0, (amount_invoiced - reported_required_fee) - cash_donation_paid].max
  end

  def cash_donation_paid
    [0, money_tendered - required_fee_paid].max
  end

  def required_fee_owed
    if invoiced? and (reported_required_fee > required_fee_paid)
        [reported_required_fee - required_fee_paid, amount_invoiced].min
    else
      0
    end
  end

  def required_fee_paid
    [reported_required_fee, money_tendered].min
  end

  def required_paid?
    money_tendered >= calculated_required_fee
  end

  def invoiced?
    payments.detect {|payment| payment.payment_method_id == PaymentMethod.invoice.id}
  end

  def overunder(only_required = false)
    if only_required
      money_tendered - calculated_required_fee
    else
      money_tendered - calculated_total
    end
  end

end
