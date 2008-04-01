class RolesController < PropertiesController
  before_filter :set_my_property_type

  def set_my_property_type
    set_property_type "role"
  end
end
