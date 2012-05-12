class MeetingMinder < ActiveRecord::Base
  # TODO: fgdb scaffold
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

  # TODO: make a cron job for this
  def self.send_all
    MeetingMinder.find(:all).each{|x|
      x.deliver if x.deliver_today?
    }
  end

  def deliver_today?
    false
  end

  def deliver
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
