class VolunteerTaskType < ActiveRecord::Base
  belongs_to :program

  has_many :contact_volunteer_task_type_counts

  def self.evaluation_type
    @@eval_type ||= VolunteerTaskType.find_by_name('evaluation')
  end

  def to_s
    description
  end

  scope :instantiables, where(:instantiable => true)
  scope :effective_on, lambda { |date|
    where('(effective_on IS NULL OR effective_on <= :date) AND
           (ineffective_on IS NULL OR ineffective_on > :date)',
          {:date => date})
  }

  def self.find_actual(*ids)
    ids.delete_if {|id| id == 0 }
    find(*ids)
  end

  def display_name
    disp = self.description.dup
    if program.name != "other"
      disp << " (" + program.display_name + ")"
    end
    return disp
  end

  def to_s
    description
  end
end
