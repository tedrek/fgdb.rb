# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  layout "application"

=begin
  protect_from_forgery
  post_list = ["create", "update", "xml_create"]
  ajax_post_list = ["new", "edit", "component_update", "update_display_area"]
  verify :method => :get, :except => post_list + ajax_post_list, :redirect_to => {:controller => "sidebar_links", :action => "index"}
  verify :method => :post, :xhr => true, :only => post_list, :redirect_to => {:controller => "sidebar_links", :action => "index"}
  verify :method => :post, :only => post_list, :redirect_to => {:controller => "sidebar_links", :action => "index"}
=end

  def with_sidebar
    "with_sidebar.html.erb"
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
      session[:unauthorized_error] = true
      redirect_to :controller => 'sidebar_links'
      return false
    end
  end

  def requires_role_or_me(contact_id, *roles)
    if has_role_or_is_me?(contact_id.to_i, *roles)
      return true
    else
      session[:unauthorized_error] = true
      redirect_to :controller => 'sidebar_links'
      return false
    end
  end
end
