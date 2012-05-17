class MeetingMinder < ActiveRecord::Base
  # explain variables in subject/body and the number of days before,
  # TODO: also "test generate" a message including the script execution.
  belongs_to :meeting

  validates_presence_of :subject
  validates_presence_of :days_before
  validates_presence_of :recipient
  validates_format_of :script, :with => /^[a-z-]*$/, :message => "can only contain letters and dashes"
  validates_format_of :recipient, :with => /^.+@[^.]+\..+$/, :message => "must be a valid email address"

  def short_desc
    "reminder to #{recipient}, #{days_before} days prior"
  end

  def minder_variables(today)
    # are the scheduled meeting attendees important? could loop the work_shifts for the meeting_date
    {:meeting_name => meeting.name, :meeting_date => today + days_before, :days_before => days_before, :todays_date => today}
  end

  def validate
    # could the script add on to the end of the text if there is some, allowing both as long as at least one is there?
    errors.add('body', 'should not be specified if a script will be ran') if body.length > 0 and script.length > 0
    errors.add('body', 'should be specified if no script will be ran') if body.length == 0 and script.length == 0
    errors.add('script', 'does not exist in the ASS meetings directory') if script.length > 0 and !File.exists?(self.script_filename)
  end

  def self.minders_for_day(today)
    Meeting.effective_in_range(today, today + 60).collect{|x| x.meeting_minders}.flatten.select{|x| x.deliver_today?(today)}
  end

  def self.deliveries_for_day(today)
    MeetingMinder.minders_for_day(today).map{|x|
      x.delivery(today)
    }
  end

  def self.send_all(today = nil)
    today ||= Date.today
    MeetingMinder.deliveries_for_day(today).each{|x|
      puts "DELIVERY: #{x.inspect}"
      # TODO: Notifier.deliver_text_minder(*x)
    }
  end

  def deliver_today?(check_date)
    meeting_date = check_date + days_before
    return false if meeting.effective_date and meeting.effective_date > meeting_date
    return false if meeting.ineffective_date and meeting.ineffective_date < meeting_date
    return false unless meeting_date.wday == meeting.weekday_id or meeting_date == meeting.shift_date
    return false if Holiday.is_holiday?(meeting_date)
    return self.meeting.generates_on_day?(meeting_date)
  end

  def delivery(today)
    [recipient, processed_subject(today), processed_body(today), self.meeting.name]
  end

  def _process(text, today)
    text = text.dup
    for k,v in minder_variables(today)
      text.gsub(/%#{k.to_s.upcase}%/, v.to_s)
    end
    return text
  end

  def self.script_dir
    '/usr/local/ass/meetings/'
  end

  def script_filename
    MeetingMinder.script_dir + script
  end

  def processed_body(today)
    if self.body
      return _process(self.body, today)
    else
      envvars = minder_variables.collect{|k,v| "#{k.to_s.upcase}=\"#{v.to_s.gsub('"', '\"')}\""}.join(" ")
      return `env #{envvars} #{self.script_filename}`
    end
  end

  def processed_subject(today)
    return _process(self.subject, today)
  end
end
