class SidebarLinksController < ApplicationController
  layout :with_sidebar

  before_filter :authorized_only, :only => ["crash"]

  protected
  def authorized_only
    requires_privileges("role_admin")
  end

  public
  def crash
    f = File.join(RAILS_ROOT, "tmp", "crash", "crash." + params[:id])
    if !File.exist?(f)
      render :text => "oops, that crash id doesn't exist."
      return
    end
    @exception_data = JSON.parse(File.read(f))
  end

  def fgss_moved
    render :layout => false
  end

  def staffsched_moved
    render :layout => false
  end
end
