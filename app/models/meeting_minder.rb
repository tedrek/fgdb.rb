class MeetingMinder < ActiveRecord::Base
  # TODO: fgdb scaffold, explain variables in subject/body and the number of days before
  belongs_to :meeting

  validates_presence_of :subject
  validates_presence_of :recipient
  validates_format_of :recipient, :with => /.+@[^.]+\..+/, :message => "must be a valid email address"

  def minder_variables
    # TODO: The database can then also export the meeting name, meeting
    # date, today's date, number of days between, the scheduled meeting
    # attendees, etc for use within the minders.
    {}
    # USE some .meeting from here
  end

  def validate
    errors.add('body', 'should not be specified if a script will be ran') if body.length > 0 and script_name.length > 0
    errors.add('body', 'should be specified if no script will be ran') if body.length == 0 and script_name.length == 0
  end

  def self.send_all(today = nil)
    today ||= Date.today
    Meeting.effective_in_range(today, today + 60).collect{|x| x.meeting_minders}.flatten.each{|x|
      x.deliver if x.deliver_today?(today)
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

  def deliver
    puts "DELIVERY"; return
    Notifier.deliver_text_minder(recipient, processed_subject, processed_body, self.meeting.name)
  end

  def _process(text)
    text = text.dup
    for k,v in minder_variables
      text.gsub(/%#{k.to_s.upcase}%/, v.to_s)
    end
    return text
  end

  def processed_body
    if self.body
      return _process(self.body)
    else
      envvars = minder_variables.collect{|k,v| "#{k.to_s.upcase}=\"#{v.to_s.gsub('"', '\"')}\""}.join(" ")
      return `env #{envvars} #{self.script_name}`
    end
  end

  def processed_subject
    return _process(self.subject)
  end
end
