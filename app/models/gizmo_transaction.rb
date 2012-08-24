module GizmoTransaction
  def gizmo_events_actual
    gizmo_events.select{|x| !x.marked_for_destruction?}
  end

  def payments_actual
    payments.select{|x| !x.marked_for_destruction?}
  end

  def inventory_is_locked?
    return false if self.id.nil? or Default["inventory_lock_end"].nil? or Default["inventory_lock_end"].length == 0
    inventory_date = Date.parse(Default["inventory_lock_end"])
    return (self.occurred_at < inventory_date)
  end

  def till_is_locked?
    return false if self.id.nil? or Default["till_lock_end"].nil? or Default["till_lock_end"].length == 0
    till_date = Date.parse(Default["till_lock_end"])
    return (self.occurred_at < till_date)
  end

  def inventory_hash
    hash = {}
    self.gizmo_events_actual.each{|x|
      hash[x.gizmo_type_id] ||= 0
      hash[x.gizmo_type_id] += x.gizmo_count
    }
    hash
  end

  def till_hash
    hash = {}
    return hash unless self.respond_to?(:payments)
    self.payments_actual.each{|x|
      hash[x.payment_method_id] ||= 0
      hash[x.payment_method_id] += x.amount_cents
    }
    hash
  end

  def has_inventory_changed?
    return false if self.id.nil?
    original = self.class.find(self.id)
    self.inventory_hash != original.inventory_hash
  end

  def has_till_changed?
    return false if self.id.nil?
    original = self.class.find(self.id)
    self.till_hash != original.till_hash
  end

  def user_is_bean_counter?
    ((Thread.current['cashier'] or Thread.current['user']) and (Thread.current['cashier'] || Thread.current['user']).has_privileges("modify_inventory"))
  end

  def validate_inventory_modifications
    if self.inventory_is_locked? and self.has_inventory_changed?
      unless user_is_bean_counter?
        errors.add("gizmos", "has changed locked inventory values without administrator privileges")
      end
    end
    if self.till_is_locked? and self.has_till_changed?
      unless user_is_bean_counter?
        errors.add("payments", "has changed locked till income values without administrator privileges")
      end
    end
  end

  def usable_gizmo_types
    if self.gizmo_context == GizmoContext.gizmo_return
      return (GizmoContext.disbursement.gizmo_types + GizmoContext.sale.gizmo_types).uniq
    else
      return self.gizmo_context.gizmo_types.effective_on(self.occurred_at || Date.today)
    end
  end

  def storecredit_priv_check
    errors.add("gizmos", "increases store credit value without cashier privileges") unless (Thread.current['cashier'] and Thread.current['cashier'].has_privileges("issue_store_credit"))
  end

  def showable_gizmo_types
    (self.gizmo_types + self.usable_gizmo_types).uniq.sort_by(&:description)
  end

  def gizmos
    gizmo_events_actual.map {|ge| ge.display_name}.join(', ')
  end

  def payment
    if payments_actual.empty?
      "free"
    else
      payments_actual.join( ", " )
    end
  end

  def calculated_subtotal_cents
    gizmo_events_actual.inject(0) {|tot,gizmo|
      tot + gizmo.total_price_cents
    }
  end

  def real_payments
    payments_actual.select {|payment| payment.payment_method_id != PaymentMethod.invoice.id}
  end

  def displayed_payment_method
    found = payments_actual.map {|payment| payment.type_description}.uniq
    t = ""
    if found.length > 1
      t = "mixed"
    elsif found.length == 1
      t = found.first # will be one of: unresolved_invoice, resolved_invoice, cash, check, coupon, credit, store_credit
    else # length < 1
      t = "free"
    end
    return t + "_transaction"
  end

  def strip_postal_code
    self.postal_code = self.postal_code.strip if self.postal_code
  end

  def invoices
    payments_actual.select {|payment| payment.payment_method_id == PaymentMethod.invoice.id}
  end

  def money_tendered_cents
    amount_from_some_payments(real_payments)
  end

  def amount_from_some_payments(arr)
    return arr.inject(0) {|total,payment| total + payment.amount_cents}
  end

  def amount_invoiced_cents
    invoices.inject(0) {|total,payment| total + payment.amount_cents}
  end

  def invoiced?
    return if ! self.respond_to?(:payments)
    payments_actual.detect {|payment| payment.payment_method.name.match(/invoice/)}
  end

  def invoice_resolved?
    return !invoice_resolved_at.nil? && invoiced?
  end

  def total_paid?
    money_tendered_cents >= calculated_total_cents
  end

  def overpaid?
    calculated_total_cents < money_tendered_cents
  end

  def contact_information
    if contact
      contact.p_id
    elsif postal_code
      ["Anonymous (#{postal_code})"]
    else
      ["Dumped"]
    end
  end

  def contact_information_web
    if contact
      contact.display_name
    elsif postal_code
      ["Anonymous (#{postal_code})"]
    else
      ["Dumped"]
    end
  end

  def hidable_contact_information
    if contact
      contact.display_name_address
    else
      return ""
    end
  end

  def should_i_hide_it?
    if gizmo_context == GizmoContext.donation or gizmo_context == GizmoContext.gizmo_return
      return true
    elsif gizmo_context == GizmoContext.sale
      return false
    else
      raise NoMethodError
    end
  end

  def is_adjustment?
    self.adjustment
  end

  def combine_cash_payments
    cashes = payments_actual.find_all{|x| x.payment_method.name == "cash"}
    if cashes.length > 0
      cash = Payment.new
      cash.payment_method = PaymentMethod.cash
      cash.amount_cents = 0
      for i in cashes
        cash.amount_cents += i.amount_cents
        i.destroy
      end
      payments_actual.reject!{|x|
        x.payment_method.name == "cash"
      }
      if cash.amount_cents > 0
        payments.build(cash.attributes)
      end
    end
    cashes.each{|x| x.mark_for_destruction}
  end

  def has_some_uneditable
    gizmo_events.collect{|x| x.editable}.select{|x| x == false}.length > 0
  end

  def hooman_class_name
    self.class.to_s.tableize.humanize.singularize.downcase
  end

  def editable_explaination
    str = ""
    if ! self.editable?
      str = "This #{self.hooman_class_name} is not editable because its associated store credit has already been spent"
    elsif self.has_some_uneditable
      str = "Some pieces of this #{self.hooman_class_name} are not editable because their associated store credit has already been spent"
    end
    return str
  end

  def html_explaination
    if !editable_explaination.blank?
      return '<pre style="background: yellow">' +
        editable_explaination +
        '</pre>'
    end
    return ""
  end

  def real_occurred_at
    self.read_attribute(:occurred_at)
  end

  def set_occurred_at_on_transaction
    self.write_attribute(:occurred_at, Time.now) if self.real_occurred_at.nil?
  end

  def occurred_at
    value = case self
           when Sale
             self.real_occurred_at
           when Donation
             self.real_occurred_at
           when GizmoReturn
             self.real_occurred_at
           when Disbursement
             self.disbursed_at
           when Recycling
             self.recycled_at
           else
             raise NoMethodError
           end
    return value || Time.now
  end

  def set_occurred_at_on_gizmo_events
    self.gizmo_events_actual.each {|event| event.occurred_at = self.occurred_at; event.save! unless event.id.nil?} # stupid has_many relationships...
  end

  #########
  protected
  #########

  def unzero_contact_id
    if contact_type != 'named'
      self.contact_id = nil
    end
  end

  def required_contact_type
    # the contact type to actually apply to a named contact who did the txn
    # used in add_contact_types
    # overridden in each class which mixes this in (not dispersments, recycling)
  end

  def add_contact_types
    if(contact and
       (contact_type == 'named' and
        required_contact_type != nil))
      for x in [required_contact_type].flatten
        if (! contact.contact_types.include?(x))
          contact.contact_types << x
        end
      end
    end
  end
end
