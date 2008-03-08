# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
  
class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_fgsched_session_id'
  before_filter :fix_null_date
  skip_before_filter :fix_null_date, :except => ["update","create"]
  
  def fix_null_date
    # go ahead and laugh at this martin. i know there's a much
    # better way to do it
    if params[:holiday]
      if params[:holiday][:holiday_date].empty?
        params[:holiday][:holiday_date] = nil
      end
    end
    if params[:meeting]
      if params[:meeting][:meeting_date]
        if params[:meeting][:meeting_date].empty?
          params[:meeting][:meeting_date] = nil
        end
      end
      if params[:meeting][:effective_date]
        if params[:meeting][:effective_date].empty?
          params[:meeting][:effective_date] = nil
        end
      end
      if params[:meeting][:ineffective_date]
        if params[:meeting][:ineffective_date].empty?
          params[:meeting][:ineffective_date] = nil
        end
      end
    end
    if params[:schedule]
      if params[:schedule][:effective_date].empty?
        params[:schedule][:effective_date] = nil
      end
      if params[:schedule][:ineffective_date].empty?
        params[:schedule][:ineffective_date] = nil
      end
    end
    if params[:shift]
      if params[:shift][:shift_date].empty?
        params[:shift][:shift_date] = nil
      end
      if params[:shift][:effective_date].empty?
        params[:shift][:effective_date] = nil
      end
      if params[:shift][:ineffective_date].empty?
        params[:shift][:ineffective_date] = nil
      end
    end
    if params[:standard_shift]
      if params[:standard_shift][:shift_date].empty?
        params[:standard_shift][:shift_date] = nil
      end
    end
    if params[:unavailability]
      if params[:unavailability][:effective_date].empty?
        params[:unavailability][:effective_date] = nil
      end
      if params[:unavailability][:ineffective_date].empty?
        params[:unavailability][:ineffective_date] = nil
      end
    end
    if params[:vacation]
      if params[:vacation][:effective_date].empty?
        params[:vacation][:effective_date] = nil
      end
      if params[:vacation][:ineffective_date].empty?
        params[:vacation][:ineffective_date] = nil
      end
    end
    if params[:work_shift]
      if params[:work_shift][:shift_date].empty?
        params[:work_shift][:shift_date] = nil
      end
      if params[:work_shift][:effective_date]
        if params[:work_shift][:effective_date].empty?
          params[:work_shift][:effective_date] = nil
        end
      end
      if params[:work_shift][:ineffective_date]
        if params[:work_shift][:ineffective_date].empty?
          params[:work_shift][:ineffective_date] = nil
        end
      end
    end
    if params[:worker]
      if params[:worker][:effective_date].empty?
        params[:worker][:effective_date] = nil
      end
      if params[:worker][:ineffective_date].empty?
        params[:worker][:ineffective_date] = nil
      end
    end
  end
end
