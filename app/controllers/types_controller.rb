class TypesController < PropertiesController
  before_filter :set_my_property_type

  def set_my_property_type
    set_property_type "type"
  end
end
