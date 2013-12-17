class PunchEntryController < ApplicationController
  layout nil

  # Display the basic punch in/out entry form
  def index
  end

  def list
    @punch_entries = PunchEntry.open
  end

  # Punch a person in, or punch them out and ask for details
  def punch
    if params[:volunteer_id].blank?
      @contact = Contact.find(:first,
                              :conditions =>
                              ['upper(first_name)=? AND upper(surname)=?',
                               params[:first_name].upcase,
                               params[:last_name].upcase])
    else
      @contact = Contact.find(params[:volunteer_id])
    end
    if @contact.nil?
      flash[:message] = "Unable to find that contact, double check the "\
                        "entered data or check with staff"
      redirect_to action: :index
      return
    end

    if params["commit"] == "Sign in"
      punch_in
    else
      punch_out
    end
    redirect_to action: :index
  end

  protected
  def punch_in
    @punch_entry = PunchEntry.new
    @punch_entry.contact = @contact
    @punch_entry.in_time = Time.now
    if @punch_entry.save
      flash[:message] = "Signed in #{@contact.first_name} #{@contact.surname}"
    else
      flash[:message] = "Error signing in: #{@punch_entry.errors}"
    end
  end

  def punch_out
    begin
      @station = VolunteerTaskType.find(params[:station].to_i)
    rescue ActiveRecord::RecordNotFound
      flash[:message] = "Please select a station when signing out"
      return
    end

    @punch_entry = PunchEntry.open().for_contact(@contact.id).first
    if @punch_entry.nil?
      flash[:message] = "Error signing out: #{@contact.first_name} "\
                        "#{@contact.surname} is not signed in"
      return
    end
    @punch_entry.out_time = Time.now

    duration = @punch_entry.out_time - @punch_entry.in_time

    # Round the duration to the nearest 15 minutes and convert to decimal hours
    duration /= 900 #
    duration = duration.round.to_f / 4

    if duration > 0
      vt = VolunteerTask.create(contact: @contact,
                                volunteer_task_type: @station,
                                duration: duration,
                                date_performed: Date.today,
                                program_id: 1,
                                created_by: 0,
                                updated_by: 0)
      vt.save!
      @punch_entry.volunteer_task = vt
    end
    @punch_entry.save
    if @punch_entry.save
      flash[:message] = "Signed out #{@contact.first_name} #{@contact.surname}"\
                        " with #{duration} hours"
    else
      flash[:message] = "Error signing out: #{@punch_entry.errors}"
    end
  end
end
