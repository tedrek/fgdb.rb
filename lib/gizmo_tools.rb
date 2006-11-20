module GizmoTools

  # Enhanced hash container for GizmoSummer objects
  # - simplify add/removal while keeping quantity correct for id
  # - simplify totalling over all items for given object attr
  # - should be generalizable to any class that maintains
  #   summable values in its attributes

  class GizmoDetailList
    include Enumerable

    attr_reader :gizmo_list, :global_options
    
    def initialize(options={})
      @gizmo_list = Hash.new
      @global_options = options
    end

    def each
      @gizmo_list.each {|k,v| yield k, v}
    end

    # add item to the list by providing its id
    # - if item id already exists, remove and re-add
    #   note: in present design, item id source is hash key so 
    #         s/b no dupes
    # - if item id not present, create new item with arg quantity
    #
    # returns item value for added item
    def add(add_id, quantity=0, options={})
      if @gizmo_list.has_key?(add_id)
        @gizmo_list.remove(add_id)
      end
      gs = GizmoSummer.new(add_id, quantity, options)
      @gizmo_list[add_id] = gs
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
    attr_accessor :quantity, :unit_price
    attr_reader :unit_required_fee, :unit_suggested_fee,
                :description, :discount_eligible

    # return extended required fee for present quantity
    def extended_required_fee
      @quantity * @unit_required_fee
    end

    # return extended suggested fee for present quantity
    def extended_suggested_fee
      @quantity * @unit_suggested_fee
    end

    # return extended suggested fee for present quantity
    def extended_gross_price
      return nil if @quantity.nil? or @unit_price.nil?
      @quantity * @unit_price
    end

    # initialize based partly on values of existing database
    # record for this GizmoType.id
    # - exception if gizmo_type id not found in table
    # - update quantity from caller
    # - set unit values for various attributes based on
    #   database values for those attributes 
    #   - for example, set unit_price to value in
    #   options[:field_hash] if present
    #
    def initialize(id,quantity=0,options={})
      begin
        gt = GizmoType.find(options[:field_hash][:gizmo_type_id].to_s.to_i)
      rescue
        raise "unable to retrieve record for gizmo_type_id #{options[:field_hash][:gizmo_type_id]}"
        return
      end

      @quantity = quantity
      @description = gt.description
      @discount_eligible = gt.discounts_apply

      return unless options.has_key?(:context)

      case options[:context]

      when 'donation'
        @unit_required_fee = (!gt.required_fee.nil? and gt.required_fee.kind_of?(Numeric)) ? gt.required_fee.to_f  : 99.99
        @unit_suggested_fee = (!gt.suggested_fee.nil? and gt.suggested_fee.kind_of?(Numeric)) ? gt.suggested_fee.to_f  : 1

      when 'sale'
        # unit price
        if ( options[:field_hash].has_key?(:unit_price)     and
            !options[:field_hash][:unit_price].nil?         and 
             options[:field_hash][:unit_price].kind_of?(Numeric)
           )
          @unit_price = options[:field_hash][:unit_price].to_f
        end
#          @discount_applied =
#            (options.has_key?(:donated_discount_rate) &&
#              !options[:donated_discount_rate].nil?   &&
#              options[:donated_discount_rate].kind_of?(Numeric) &&
#              options[:donated_discount_rate] < 1)    ?
#              @unit_price * @quantity * options[:donated_discount_rate] :
#              0
      end
    end

  end

end
