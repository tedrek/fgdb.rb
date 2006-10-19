# create and manipulate sums of various attributes attached to
# gizmo types, such as required_fee, suggested_fee,
# standard_extended_discount, etc, based on the
# quantity provided by client

class GizmoSummer
  attr_accessor :quantity
  attr_reader  :unit_required_fee, :unit_suggested_fee, :description

  # return extended required fee for present quantity
  def extended_required_fee
    @quantity * @unit_required_fee
  end

  # return extended suggested fee for present quantity
  def extended_suggested_fee
    @quantity * @unit_suggested_fee
  end

  # initialize based partly on values of existing database
  # record for this GizmoType.id
  # - exception if id not found in database
  # - update quantity from caller
  # - set unit values for various attributes based on
  #   database values for those attributes 
  #   - for example, set required_fee to value of GizmoType.fee
  #     if the GizmoType.fee_is_required flag is TRUE
  def initialize(id,quantity=0, options={})
    # parse options
    @discount_applied = 0
    @discount_applied = options[:discount_applied] if
      !options[:discount_applied].nil? and
        options[:discount_applied].kind_of?(Numeric)

    begin
      gt = GizmoType.find(id.to_s.to_i)
    rescue
      raise "unable to retrieve record for id #{id}"
    end

      @quantity = quantity
      @quantity = (!quantity.nil? and quantity.kind_of?(Numeric)) ? quantity  : 0

      @description = gt.description

      # donations-related amounts
      if gt.fee_is_required
        @unit_suggested_fee = 0
        @unit_required_fee = (!gt.fee.nil? and gt.fee.kind_of?(Numeric)) ? gt.fee  : 99.99
      else
        @unit_required_fee = 0
        @unit_suggested_fee = (!gt.fee.nil? and gt.fee.kind_of?(Numeric)) ? gt.fee  : 1
      end
      @unit_required_fee = @unit_required_fee.to_f
      @unit_suggested_fee = @unit_suggested_fee.to_f

      # sale_txns-related
      unit_price = (!gt.unit_price.nil? and gt.unit_price.kind_of?(Numeric)) ? gt.unit_price  : 99.99
      # rename this to standard_discount
      # and it needs to be calculated based on discount schedule id
      @standard_extended_discount = (!gt.standard_extended_discount.nil? and gt.standard_extended_discount.kind_of?(Numeric)) ?  gt.standard_extended_discount  : 0.0
      @extended_price = unit_price * @quantity
      @standard_extended_discount.to_f
      @extended_price.to_f
  end

end
