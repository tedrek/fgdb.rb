class PunchEntriesController < ApplicationController
  layout 'with_sidebar'
  before_filter :find_contact, only: [:punch_in, :punch_out]

  def get_required_privileges
    a = super
    a << {:only => ['edit', 'list', 'today', 'flagged', 'update'],
          :privileges => ['admin_punch_entries']}
    return a
  end

  #
  # The basic user interface, to be accessible by anonymous users
  #

  def index
    render :index, layout: 'basic'
  end

  def sign_in
    render :sign_in, layout: 'basic'
  end

  def sign_out
    render :sign_out, layout: 'basic'
  end

  # Punch a person in
  def punch_in
    @punch_entry = PunchEntry.sign_in(@contact)
    if @punch_entry.save
      flash[:message] = "Signed in #{@contact.first_name} #{@contact.surname} "\
                        "(ID ##{@contact.id})"
    else
      flash[:message] = "Error signing in: #{@punch_entry.errors}"
    end

    redirect_to action: :index
  end

  # Punch them out and ask for details
  def punch_out
    begin
      @station = VolunteerTaskType.find(params[:station].to_i)
    rescue ActiveRecord::RecordNotFound
      flash[:message] = "Please select a station when signing out"
      redirect_to action: :sign_out
      return
    end

    @punch_entry = PunchEntry.open().for_contact(@contact.id).first
    if @punch_entry.nil?
      flash[:message] = "Error signing out: #{@contact.first_name} "\
                        "#{@contact.surname} is not signed in"
      redirect_to action: :index
      return
    end
    @punch_entry.station = @station
    @punch_entry.out_time = Time.zone.now
    @punch_entry.flagged = true if @station.hours_multiplier != 1
    if @punch_entry.save
      flash[:message] = "Signed out #{@contact.first_name} #{@contact.surname}"\
                        " with #{@punch_entry.duration} hours"
    else
      flash[:message] = "Error signing out: #{@punch_entry.errors}"
    end
    redirect_to action: :index
  end

  #
  # Admin level actions
  #

  def edit
    @punch_entry = PunchEntry.find(params[:id])
  end

  def list
    @punch_entries = PunchEntry.paginate(per_page: 25,
                                         page: params[:page],
                                         order: 'id ASC')
  end

  def today
    @punch_entries = PunchEntry
      .where('in_time >= ?',
            [Date.today.to_time_in_current_zone])
      .paginate(per_page: 25,
                page: params[:page],
                order: 'id ASC')
    render :list
  end

  def flagged
    @punch_entries = PunchEntry
      .where(flagged: true)
      .paginate(per_page: 25,
                page: params[:page],
                order: 'id ASC')
    render :list
  end

  def update
    @punch_entry = PunchEntry.find(params[:id])

    date = Time.zone.parse(params[:punch_entry][:in_time][:date])
    time = Time.zone.parse(params[:punch_entry][:in_time][:time])
    params[:punch_entry][:in_time] = date.change(hour: time.hour,
                                                 min: time.min)

    date = Time.zone.parse(params[:punch_entry][:out_time][:date])
    time = Time.zone.parse(params[:punch_entry][:out_time][:time])
    if !time.nil?
      params[:punch_entry][:out_time] = date.change(hour: time.hour,
                                                    min: time.min)
    else
      params[:punch_entry].delete(:out_time)
    end

    if @punch_entry.update_attributes(params[:punch_entry])
      flash[:message] = "Updated PunchEntry ##{@punch_entry.id}"
    else
      flash[:message] = "Error saving entry: #{@punch_entry.errors}"
    end
    redirect_to action: :list
  end

  protected
  def find_contact
    if params[:volunteer_id].blank?
      @contact = Contact.find(:first,
                              :conditions =>
                              ['upper(first_name)=? AND upper(surname)=?',
                               params[:first_name].upcase,
                               params[:last_name].upcase])
    else
      @contact = Contact.find_by_id(params[:volunteer_id])
    end
    if @contact.nil?
      flash[:message] = "Unable to find that contact, double check the "\
                        "entered data or check with staff"
      redirect_to action: :index
      return
    end
  end
end
