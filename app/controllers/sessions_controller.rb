# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  filter_parameter_logging "password"

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login].to_s.strip, params[:password])
    if self.current_user
      self.current_user.will_not_updated_timestamps!
      self.current_user.last_logged_in = Date.today
      self.current_user.save
    end
    flash[:error] = "invalid username/password" unless logged_in?
    rerender()
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    @current_user = nil
    session[:logout_message] = true
    redirect_to :controller => "sidebar_links", :action => "index"
  end

  protected

  def rerender
    render :update do |page|
      if params[:goto]
        page.redirect_to(eval(params[:goto][:params]))
      else
        page.redirect_to("")
      end
    end
  end
end
