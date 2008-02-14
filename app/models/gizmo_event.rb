

class GizmoEvent < ActiveRecord::Base
  usesguid

  has_one :donation
  has_one :sale
  has_one :disbursement
  has_one :recycling
  belongs_to  :gizmo_type
  belongs_to  :gizmo_context

  validates_presence_of :gizmo_count
  validates_presence_of :gizmo_type_id
  validates_presence_of :gizmo_context_id

  has_many    :gizmo_events_gizmo_typeattrs,
              :dependent => :destroy

  def display_name
    "%i %s%s" % [gizmo_count, gizmo_type.description, gizmo_count > 1 ? 's' : '']
  end

  def gizmo_attrs
    if gizmo_type and gizmo_context
      gizmo_type.relevant_attrs(gizmo_context)
    else
      []
    end
  end

  def valid_gizmo_count?
     gizmo_count.is_a?(Fixnum) and gizmo_count > 0
  end

  def attry_description(options = {})
    attrs = {}
    gizmo_events_gizmo_typeattrs.each {|bridge|
      next unless bridge.value
      next if( options[:ignore].respond_to?('include?') &&
               (options[:ignore].include?(bridge.gizmo_typeattr.gizmo_attr.name)) )
      attrs[bridge.gizmo_typeattr.gizmo_attr.name] = bridge.value
    }

    if attrs.empty?
      gizmo_type.description
    else
      gizmo_type.description + " (" +
        attrs.map {|name,value|
        "%s: %s" % [name, value]
      }.join(', ') + ")"
    end
  end

  def possible_attrs
    if gizmo_type
      gizmo_type.possible_attrs
    else
      GizmoAttr.find(:all)
    end
  end

  def gizmo_typeattrs
    if gizmo_type and gizmo_context
      gizmo_type.relevant_typeattrs(gizmo_context)
    else
      []
    end
  end

  def percent_discount(schedule)
    return 0 unless schedule && gizmo_type
    ( ( 1.0 - gizmo_type.multiplier_to_apply(schedule) ) * 100 ).ceil
  end

  def total_price
    return 0 unless unit_price and gizmo_count
    unit_price.to_f * gizmo_count
  end

  def discounted_price(schedule)
    return total_price unless schedule && gizmo_type
    total_price * gizmo_type.multiplier_to_apply(schedule)
  end

  def mostly_empty?
    ((! gizmo_type_id) or (! gizmo_count))
  end

  def required_fee
    gizmo_count.to_i * gizmo_type.required_fee
  end

  def suggested_fee
    gizmo_count.to_i * gizmo_type.suggested_fee
  end

  def to_s
    "id[#{id}]; type[#{gizmo_type_id}]; context[#{gizmo_context_id}]; count[#{gizmo_count}]"
  end

  def initialize_gizmo_attrs
    attrs = {}
    gizmo_events_gizmo_typeattrs.each {|attr|
      attrs[attr.gizmo_typeattr.gizmo_attr.name] = attr.value
    }
    attrs
  end

  def method_missing_with_gizmo_attrs(sym, *args, &block)
    attr_name = sym.to_s.sub(/=/, '')
    if possible_attrs.detect {|attr| attr.name == attr_name }
      @gizmo_attrs ||= initialize_gizmo_attrs
      if attr_name == sym.to_s
        return @gizmo_attrs[attr_name]
      else
        return @gizmo_attrs[attr_name] = args[0]
      end
    end
    method_missing_without_gizmo_attrs(sym, *args, &block)
  end
  alias :method_missing_without_gizmo_attrs :method_missing
  alias :method_missing :method_missing_with_gizmo_attrs

  before_save :setup_gizmo_attrs
  def setup_gizmo_attrs
    if @gizmo_attrs
      self.gizmo_events_gizmo_typeattrs = gizmo_typeattrs.map {|typeattr|
        attr_entry = GizmoEventsGizmoTypeattr.new
        attr_entry.gizmo_event = self
        attr_entry.gizmo_typeattr = typeattr
        attr_entry.value = @gizmo_attrs[typeattr.gizmo_attr.name]
        attr_entry
      }
    end
  end
end
