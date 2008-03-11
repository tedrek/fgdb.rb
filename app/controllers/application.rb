# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
  
class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_fgsched_session_id'
  before_filter :fix_null_date
  skip_before_filter :fix_null_date, :except => ["update","create"]

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
