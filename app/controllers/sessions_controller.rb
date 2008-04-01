# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    flash[:error] = "invalid username/password" unless logged_in?
    rerender()
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    @current_user = nil
    rerender()
  end

  protected

  def rerender
    render :update do |page|
      page.replace("login_box", :partial => "you_are_here")
      page.replace("sidebar", :partial => "sidebar_links/sidebar")
    end
  end
end
