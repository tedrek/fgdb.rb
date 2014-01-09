class PunchEntry < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_task, dependent: :destroy
  has_many :notations, as: :notatable, dependent: :destroy

  validates :in_time, presence: true
  validates :contact, presence: true
  validate :station_available

  before_save :update_volunteer_task

  after_initialize :set_defaults, :if => :new_record?

  scope :for_contact, ->(id) {
    where(contact_id: id).order('in_time DESC')
  }

  scope :open, where(out_time: nil)

  # Sign in a contact
  def self.sign_in(person)
    previous_entry = open.for_contact(person.id).first
    return new(contact: person) if previous_entry.nil?

    # Allow a grace period of 30 minutes where an old entry can be re-used
    if (Time.zone.now - previous_entry.in_time) <= 30.minutes
      return previous_entry
    end

    # Otherwise flag the old entry for review
    previous_entry.flagged = true
    previous_entry.out_time = Time.zone.now
    previous_entry.notations.create(content: "Superseded by new entry at "\
                                             "#{Time.zone.now}",
                                    contact: person)
    previous_entry.save!

    return new(contact: person)
  end

  def duration
    return 0 if out_time.nil? or flagged
    d = out_time - in_time
    # Round to the nearest 15 minutes and convert to decimal hours
    d /= 900
    d = d.round.to_f / 4
    return d
  end

  def station
    volunteer_task.nil? ? @station : volunteer_task.volunteer_task_type
  end

  def station=(id)
    @station = VolunteerTaskType.find_by_id(id)
    if !@station.nil? and !volunteer_task.nil?
      volunteer_task.volunteer_task_type = @station
    end
  end

  protected

  def set_defaults
    self.in_time ||= Time.zone.now
  end

  # Check that the station has been set if it will be needed before saving
  def station_available
    return if duration == 0 or flagged
    if station.nil?
      errors.add :station, "must be set when updating the times."
    end
  end

  def update_volunteer_task
    return if out_time.nil?
    return unless
      in_time_changed? or
      out_time_changed? or
      flagged_changed? or
      new_record?

    if duration > 0
      if volunteer_task.nil?
        vt = VolunteerTask.create(contact: contact,
                                  volunteer_task_type: @station,
                                  duration: duration,
                                  date_performed: in_time.to_date,
                                  program_id: 1,
                                  created_by: 0,
                                  updated_by: 0)
        vt.save!
        self.volunteer_task = vt
      else
        volunteer_task.duration = duration
        volunteer_task.save
      end
    elsif (!volunteer_task.nil?)
      volunteer_task.destroy
      self.volunteer_task = nil
    end
  end
end
