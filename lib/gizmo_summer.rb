# create and manipulate sums of various attributes attached to
# gizmo types, such as required_fee, suggested_fee, based on the
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
  def initialize(id,quantity=0)
    begin
      gt = GizmoType.find(id.to_s.to_i)
    rescue
      raise "unable to retrieve record for id #{id}"
    end

      @quantity = quantity

      @description = gt.description

      if gt.fee_is_required
        @unit_suggested_fee = 0
        @unit_required_fee = (!gt.fee.nil? and gt.fee.kind_of?(Numeric)) ? gt.fee  : 99.99
      else
        @unit_required_fee = 0
        @unit_suggested_fee = (!gt.fee.nil? and gt.fee.kind_of?(Numeric)) ? gt.fee  : 1
      end
      @unit_required_fee = @unit_required_fee.to_f
      @unit_suggested_fee = @unit_suggested_fee.to_f
  end

end
