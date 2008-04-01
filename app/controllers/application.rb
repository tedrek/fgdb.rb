# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  layout "application"

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at, :created_by, :updated_by, :lock_version]
  end

  def with_sidebar
    "with_sidebar.rhtml"
  end

  before_filter :authorize

  def authorize
    x = current_user()
    if x.kind_of?(User)
      @current_user = x
    else
      @current_user = nil
    end
    Thread.current['user'] = @current_user
  end

  def is_me?(contact_id)
    current_user and current_user.contact_id == contact_id.to_i
  end

  def has_role_or_is_me?(contact_id, *roles)
     (contact_id and is_me?(contact_id)) or has_role?(*roles)
  end

  def has_role?(*roles)
    logged_in? and current_user.has_role?(*roles)
  end

  def requires_role(*roles)
    if has_role?(*roles)
      return true
    else
      redirect_to :controller => 'sidebar_links', 'unauthorized_error' => true
      return false
    end
  end

  def requires_role_or_me(contact_id, *roles)
    if has_role_or_is_me?(contact_id.to_i, *roles)
      return true
    else
      redirect_to :controller => 'sidebar_links', 'unauthorized_error' => true
      return false
    end
  end
end
