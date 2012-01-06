class LogsController < ApplicationController
  layout :with_sidebar

  def get_required_privileges
    a = super
    a << {:privileges => ['view_logs']}
    return a
  end

  def index
  end

  def show_log
  end
end
