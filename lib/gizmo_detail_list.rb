# Enhanced hash container for GizmoSummer objects
# - simplify add/removal while keeping quantity correct for id
# - simplify totalling over all items for given object attr
# - should be generalizable to any class that maintains
#   summable values in its attributes

class GizmoDetailList
  include Enumerable
  require 'gizmo_summer'

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
