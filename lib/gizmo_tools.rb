module GizmoTools

  # Enhanced hash container for GizmoSummer objects
  # - simplify add/removal while keeping quantity correct for id
  # - simplify totalling over all items for given object attr
  # - should be generalizable to any class that maintains
  #   summable values in its attributes

  class GizmoDetailList
    include Enumerable

    attr_reader :gizmo_list
    
    def initialize
      @gizmo_list = Hash.new
    end

    def each
      @gizmo_list.each {|k,v| yield k, v}
    end

    # add (existing or new) item to the list by providing its id
    # - if item already exists, just add arg quantity to current
    # - if item not present, create new item with arg quantity
    #
    # returns item value for added item
    def add(add_id, quantity=0)
      if @gizmo_list.has_key?(add_id)
        @gizmo_list[add_id].quantity += quantity
      else
        gs = GizmoSummer.new(add_id,quantity)
        @gizmo_list[add_id] = gs
      end
      return @gizmo_list[add_id]
    end

    def remove(id)
      @gizmo_list.delete(id)
    end

    # sums every item's value for given attribute
    def total(attr_name)
      sum = @gizmo_list.values.inject(0) {|sum, o| sum + o.send(attr_name.to_sym) }
    end

  end

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

        @unit_required_fee = (!gt.required_fee.nil? and gt.required_fee.kind_of?(Numeric)) ? gt.required_fee.to_f  : 99.99
        @unit_suggested_fee = (!gt.suggested_fee.nil? and gt.suggested_fee.kind_of?(Numeric)) ? gt.suggested_fee.to_f  : 1
    end

  end

end
