# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

module ActionController
  class AbstractRequest
    def my_port
      return @fgdb_internal_port || @env["SERVER_PORT"].to_i
    end

    def port_string
      (my_port == standard_port) ? '' : ":#{my_port}"
    end

    def set_port(port_part)
      @host_with_port = nil
      @fgdb_internal_port = port_part.to_i
    end
  end
end

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  layout "application"
  helper :cashiers
  helper :conditions
  helper :sidebar

  rescue_from 'Exception', :with => :process_exception

  def rescue_as_normal
    return false
  end

  def process_exception(exception)
    if rescue_as_normal
      return rescue_action(exception)
    else
      return rescue_action_locally(exception)
    end
  end

  def rescues_path(thing)
    if rescue_as_normal
      return super(thing)
    elsif thing == "layout"
      return "app/views/layouts/application.html.erb"
    else
      return "app/views/sidebar_links/error.html.erb"
    end
  end

  before_filter :set_correct_server_port
  def set_correct_server_port
    orig_host = request.env["HTTP_FGDB_PROXY_HTTP_HOST"]
    return if orig_host.nil?
    host_part, port_part = orig_host.split(":")
    return if port_part.nil?
    request.set_port(port_part)
    return true
  end

=begin
    protect_from_forgery
    post_list = ["create", "update", "xml_create"]
    ajax_post_list = ["new", "edit", "component_update", "update_display_area"]
    verify :method => :get, :except => post_list + ajax_post_list, :redirect_to => {:controller => "sidebar_links", :action => "index"}
    verify :method => :post, :xhr => true, :only => post_list, :redirect_to => {:controller => "sidebar_links", :action => "index"}
    verify :method => :post, :only => post_list, :redirect_to => {:controller => "sidebar_links", :action => "index"}
=end

  before_filter :set_cashier
  def set_cashier
    uid = _set_cashier(params)
    if uid && (u = User.find_by_cashier_code(uid.to_i))
      Thread.current['cashier'] = u
    else
      Thread.current['cashier'] = nil
      logger.warn "Cashier not found" # die better
    end
  end

  def _set_cashier(hash)
    return hash["cashier_code"] if hash.keys.include?("cashier_code")
    for i in hash.values.select{|x| x.class == Hash}
      x = _set_cashier(hash)
      return x if !x.nil?
    end
    return nil
  end

  def current_cashier
    Thread.current['cashier']
  end

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

  def required_privileges(action)
    requires = []
    base_action = action.split("/").first
    if base_action == "" and params
      base_action = params[:action]
    end
    all = []
    get_required_privileges.each{|x|
      all << [x[:only], x[:except]]
      if (x[:only].nil? || x[:only].include?(action) || x[:only].include?(base_action)) && (x[:except].nil? || !(x[:except].include?(action) || x[:except].include?(base_action)))
        requires << x[:privileges]
      end
    }
    all = all.flatten.uniq
    if !all.include?(action)
#      puts "WARNING: action #{action}, for which the list of required privileges has been requested, is apparently unknown to the privilege system"
      nil
    end
    requires.each{|x| x.flatten!}
    requires
  end

  helper_method :has_required_privileges

  def self.has_required_privileges(action)
    self.new.has_required_privileges(action)
  end

  def has_required_privileges(action)
    required_privileges(action).each{|x|
      if !has_privileges(x)
        return false
      end
    }
    return true
  end

  def self.sb_has_required_privileges(action)
    self.new._internal_sb_has_required_privileges(action)
  end

  def _internal_sb_has_required_privileges(action) # TODO: should this be self.has_required_privileges? so Controller.has_required does one thing, while Controller.new.has_required does the other
    required_privileges(action).each{|x|
      if !has_privileges(_privis_to_out_of_page(x))
        return false
      end
    }
    return true
  end

  def get_required_privileges
    a = []
    a << {:only => ["/contact_condition_everybody"], :privileges => ['manage_contacts']}
    a << {:only => ["/admin_inventory_features"], :privileges => ['role_admin']}
    return a
  end

  def _privis_to_out_of_page(privs)
    mappings = {"contact_nil" => "has_contact", "contact_" => "has_contact"}
    res = privs.map{|x|
      mappings[x] || x
    }
#    puts res.inspect
    return res
  end

  before_filter :authorize_to_required_privileges

  def authorize_to_required_privileges
    if has_required_privileges(params[:action])
      return true
    else
      session[:unauthorized_error] = true
      session[:unauthorized_params] = params.inspect
      redirect_to :controller => 'sidebar_links'
      return false
    end
  end

  # start auth junk

  def has_privileges(*privs)
    User.current_user.has_privileges(*privs)
  end

  # end auth junk

  before_filter :fix_null_date

  def fix_this_null_date (c1, c2)
    if params[c1]
      if params[c1][c2]
        if params[c1][c2].empty?
          params[c1][c2] = nil
        end
      end
    end
  end

  def fix_null_date
    return if !([:coverage_types, :customizations, :frequency_types, :holidays, :jobs, :meetings, :rr_items, :rr_sets, :schedules, :shifts, :standard_shifts, :unavailabilities, :vacations, :weekdays, :workers, :worker_types, :work_shifts].map{|x| x.to_s}.include?(params[:controller]) && ["update","create"].include?(params[:action]))
    # fields to check. these are date fields that allow NULL
    # values in the database. the dhtml-calendar plugin passes an
    # empty string when the date is left blank, this turns into
    # an arbitrary and unwanted date rather than a NULL. fix
    # these by explicitly setting these values to nil. 
    fix_this_null_date(:holiday, :holiday_date)
    fix_this_null_date(:meeting, :meeting_date)
    fix_this_null_date(:meeting, :effective_date)
    fix_this_null_date(:meeting, :ineffective_date)
    fix_this_null_date(:rr_set, :effective_date)
    fix_this_null_date(:rr_set, :ineffective_date)
    fix_this_null_date(:schedule, :effective_date)
    fix_this_null_date(:schedule, :ineffective_date)
    fix_this_null_date(:shift, :shift_date)
    fix_this_null_date(:shift, :effective_date)
    fix_this_null_date(:shift, :ineffective_date)
    fix_this_null_date(:standard_shift, :shift_date)
    fix_this_null_date(:unavailability, :effective_date)
    fix_this_null_date(:unavailability, :ineffective_date)
    fix_this_null_date(:vacation, :effective_date)
    fix_this_null_date(:vacation, :ineffective_date)
    fix_this_null_date(:work_shift, :shift_date)
    fix_this_null_date(:work_shift, :effective_date)
    fix_this_null_date(:work_shift, :ineffective_date)
    fix_this_null_date(:worker, :effective_date)
    fix_this_null_date(:worker, :ineffective_date)
  end
end
