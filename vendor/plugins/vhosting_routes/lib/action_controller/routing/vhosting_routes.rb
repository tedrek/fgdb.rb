module ActionController::Routing::VhostingRoutes
  def self.included(base)
    base.class_eval do
      alias_method_chain :recognition_conditions, :vhosting
    end
  end

  def recognition_conditions_with_vhosting
    res = recognition_conditions_without_vhosting
    res << "conditions[:host].match(env[:host])" if conditions[:host]
    res
  end
end
