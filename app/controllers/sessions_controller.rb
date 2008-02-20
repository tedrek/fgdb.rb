# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    flash[:error] = "invalid username/password" unless logged_in?
    render :update do |page|
      page.replace("login_box", :partial => "you_are_here")
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    @current_user = nil
    render :update do |page|
      page.replace("login_box", :partial => "you_are_here")
    end
  end

  def dump
    render :text => "<pre>#{session.to_yaml}</pre>"
  end
end
