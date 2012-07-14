class DonationsController < TransactionController
  def invoices
    if params[:contact]
      @contact = Contact.find_by_id(params[:contact][:id].to_i)
    end
    if @contact
      @invoices = @contact.unresolved_donations.sort_by(&:occurred_at)
      @transaction = Donation.new(:contact => @contact)
    end
    if @contact and params[:invoices]
      _apply_line_item_data(@transaction)
      gt = GizmoType.find_by_name("invoice_resolved")
      params[:invoices].each do |k|
        d = Donation.find_by_id(k)
        @transaction.gizmo_events << GizmoEvent.new(:gizmo_type => gt, :unit_price_cents => d.invoice_amount_cents, :invoice_donation => d, :gizmo_count => 1, :gizmo_context => @gizmo_context)
      end
      if @transaction.calculated_under_pay < 0
        @transaction.payments << Payment.new(:amount_cents => -1 * @transaction.calculated_under_pay, :payment_method => PaymentMethod.invoice)
      end
      @transaction.valid? # add errors, otherwise mine below will prevent the check
      # TODO: CHECK OTHER THINGS: ..?
      for i in @transaction.gizmo_events
        @transaction.errors.add('invoices', 'are already resolved') if i.invoice_donation.resolved?
      end
      # NOTE: not valid?, as I am adding errors manually after
      if @transaction.errors.length == 0
        @transaction.save
        @show_id = @transaction.id
        @contact = nil
      end
    end
  end

  def civicrm_sync
    _civicrm_sync
  end

  protected

  def default_condition
    "created_at"
  end
end
