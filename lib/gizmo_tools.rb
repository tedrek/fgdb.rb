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
      @gizmo_list[add_id] = gs unless gs.nil?
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
    attr_reader :unit_required_fee, :unit_suggested_fee,
                :description, :discount_eligible, 
                :discount_rate, :discount_applied,
                :unit_price, :unit_discount, 
                :extended_price

    # return extended required fee for present quantity
    def extended_required_fee
      return 0.0 if @quantity.nil? or @unit_required_fee.nil?
      @quantity * @unit_required_fee
    end

    # return extended suggested fee for present quantity
    def extended_suggested_fee
      return 0.0 if @quantity.nil? or @unit_suggested_fee.nil?
      @quantity * @unit_suggested_fee
    end

    # extended gross price before discount
    def extended_gross_price
      return 0.0 if @quantity.nil? or @unit_price.nil?
      @quantity * @unit_price
    end

    # extended line discount
    def extended_discount
      return 0.0 if @quantity.nil? or @unit_discount.nil?
      @discount_applied = @quantity * @unit_discount
    end

    # net extended price
    def extended_net_price
      return 0.0 if extended_gross_price.nil? or extended_discount.nil?
      @extended_price = extended_gross_price - extended_discount
    end

    # initialize based partly on values of existing database
    # record for this GizmoType.id
    # - exception if gizmo_type id not found in table
    # - update quantity from caller
    # - set values for various attributes based on
    #   database or form values for those attributes, depending
    #   on their source
    #   - for example, set unit_price to form value given in
    #   options[:field_hash][:unit_price] if present
    #
    def initialize(id,quantity=0,options={})
      begin
        gt = GizmoType.find(options[:field_hash][:gizmo_type_id].to_s.to_i)
      rescue
        #raise "unable to retrieve record for gizmo_type_id #{options[:field_hash][:gizmo_type_id]}"
        return nil
      end

      @quantity = quantity
      @description = gt.description
      @discount_eligible = gt.discounts_apply
      @discount_rate = set_discount_rate(options)

      return unless options.has_key?(:context)

      case options[:context]

      when 'donation'
        @unit_required_fee = (!gt.required_fee.nil? and gt.required_fee.kind_of?(Numeric)) ? gt.required_fee.to_f  : 99.99
        @unit_suggested_fee = (!gt.suggested_fee.nil? and gt.suggested_fee.kind_of?(Numeric)) ? gt.suggested_fee.to_f  : 1

      when 'sale'
        # unit price
        if ( options[:field_hash].has_key?(:unit_price)     and
            !options[:field_hash][:unit_price].nil?         and 
             options[:field_hash][:unit_price].to_f
           )
          @unit_price = options[:field_hash][:unit_price].to_f
        end
        # unit discount
        if (@discount_eligible)
          @unit_discount = @unit_price * @discount_rate
        end
      end
    end

    private

    def set_discount_rate(options={})
      unless (@discount_eligible)
        return 0.0
      end

      # needs a ticket but I'm offline  :-(
      # here we pretend that all gizmo types are eligible for a
      # donated discount rate if eligible at all; date structure
      # to support multiple discount rate needs to be designed
      discount_type = 'donated'

      discount_rate = nil
      case discount_type
      when 'donated'
        if ( options.has_key?(:donated_discount_rate)       and
            !options[:donated_discount_rate].nil?           and
             options[:donated_discount_rate].to_f
           )
          discount_rate = options[:donated_discount_rate].to_f
        end
      when 'resale'
        if ( options.has_key?(:resale_discount_rate)       and
            !options[:resale_discount_rate].nil?           and
             options[:resale_discount_rate].to_f
           )
          discount_rate = options[:resale_discount_rate].to_f
        end
      end
      # sanity check
      if ( discount_rate.nil?                             or
          !discount_rate.kind_of?(Numeric)                or
           discount_rate > 1                              or
           discount_rate < 0
         )
        discount_rate = 0.0 
      end
      return discount_rate
    end

  end

end
