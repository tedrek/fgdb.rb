module DisbursementsHelper
  include TransactionHelper

  def base_controller
    return '/disbursements'
  end

  def columns
    [
      Column.new(Disbursement, :name => 'disbursement_type', :sortable => false),
      Column.new(Disbursement, :name => 'recipient', :sortable => false,
                 :eval => 'disbursement.recipient.display_name'),
      Column.new(Disbursement, :name => 'gizmos', :sortable => false),
      Column.new(Disbursement, :name => 'disbursed_at'),
    ]
  end
end
