class ReportsController < ApplicationController
  MINIMUM_COMPAT_VERSION=2

  def check_compat
    if !params[:version] || params[:version].empty? || params[:version].to_i < MINIMUM_COMPAT_VERSION  
      render :xml => {:compat => false, :your_version => params[:version].to_i, :minimum_version => MINIMUM_COMPAT_VERSION, :message => "You need to update your version of printme\nTo do that, go to System, then Administration, then Update Manager. When update manager comes up, click Check and then click Install Updates.\nAfter that finishes, run printme again."}
    else
      render :xml => {:compat => true}
    end
  end
end
