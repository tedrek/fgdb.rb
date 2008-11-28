module ActionController::Routing::VhostingRouteSets
  def self.included(base)
    base.class_eval do
      alias_method_chain :extract_request_environment, :vhosting
    end
  end

  def extract_request_environment_with_vhosting(request)
    hash = extract_request_environment_without_vhosting(request)
    hash[:host] = request.env['SERVER_NAME']
    hash
  end
end

