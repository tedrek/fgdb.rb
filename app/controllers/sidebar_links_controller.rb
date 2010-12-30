class SidebarLinksController < ApplicationController
  layout :with_sidebar

  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['role_admin'], :only => ["crash"]}
    a
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
