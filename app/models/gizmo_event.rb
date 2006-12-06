require 'ajax_scaffold'

class GizmoEvent < ActiveRecord::Base
  has_one :donation
  has_one :sale_txn
  belongs_to  :gizmo_type
  belongs_to  :gizmo_context

  validates_presence_of :gizmo_count
  validates_presence_of :gizmo_type_id
  validates_presence_of :gizmo_context_id

  has_many    :gizmo_events_gizmo_typeattrs,
              :dependent => :destroy

  def gizmo_attrs
    if gizmo_type and gizmo_context
      gizmo_type.relevant_attrs(gizmo_context)
    else
      []
    end
  end

  def gizmo_typeattrs
    if gizmo_type and gizmo_context
      gizmo_type.relevant_typeattrs(gizmo_context)
    else
      []
    end
  end

  def mostly_empty?
    ((! gizmo_type_id) and (! gizmo_count))
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
    if gizmo_attrs.find {|attr| attr.name == attr_name }
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
