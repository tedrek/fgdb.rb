require 'ajax_scaffold'

class Contact < ActiveRecord::Base
  has_and_belongs_to_many :contact_types
  has_many :contact_methods, :dependent => true
  has_many :contact_method_types, :through => :contact_methods

  # many to many self referential relationship (source and sink can be
  # used to determine direction of relationship)
  has_many :relationships_as_source, :foreign_key => 'source_id', :class_name => 'Relationship'
  has_many :relationships_as_sink,   :foreign_key => 'sink_id',   :class_name => 'Relationship'
  has_many :sources,  :through => :relationships_as_sink
  has_many :sinks,    :through => :relationships_as_source

  has_many :donations
  has_many :volunteer_tasks

  # acts_as_userstamp

  def is_organization?
    self.is_organization
  end

  def is_person?
    ! self.is_organization?
  end

  def hours_actual
    volunteer_tasks.inject(0.0) do |total,task|
      total += task.duration
    end
  end

  def hours_effective
    volunteer_tasks.inject(0.0) do |total,task|
      total += task.effective_duration
    end
  end

  def last_few_volunteer_tasks
    volunteer_tasks.sort_by {|v_t| v_t.date_performed }[-3..-1]
  end

  def default_volunteer_task_types
    last_few = last_few_volunteer_tasks
    if( last_few.length > 1 and
          last_few.map {|v_t| v_t.volunteer_task_types.sort}.uniq.length == 1 )
      return last_few.first.volunteer_task_types
    else
      return []
    end
  end

  def to_s
    display_name
  end

  def screen_sortby
    display_name
  end

  def display_name
    if is_person?
      if (self.first_name || self.middle_name || self.surname) &&
          !(self.first_name + self.middle_name + self.surname).empty?
        "%s %s %s" % [self.first_name, self.middle_name, self.surname]
      else
        '(person without name)'
      end
    else
      if self.organization && ! self.organization.empty?
        self.organization
      else
        '(organization without name)'
      end
    end
  end

  def csz
    "#{city}, #{state_or_province}  #{postal_code}"
  end

  def display_name_address
    disp = []
    disp.concat(display_name.to_a) unless
      display_name.nil? or display_name.size == 0
    disp.concat(display_address.to_a) unless 
      display_address.nil? or display_address.size == 0
    return disp
  end

  def display_address
    dispaddr = []
    dispaddr.push(address)
    dispaddr.push(extra_address) unless 
      extra_address.nil? or extra_address == ''
    dispaddr.push(csz)
    dispaddr.push(country) unless 
      country.nil? or country == '' or country.upcase =~ /^USA*$/
    return dispaddr
  end

  def relationships
    (relationships_as_source + relationships_as_sink).uniq
  end

  def types
    contact_types.join(' ')
  end

  def discount_schedule_id
    1
  end

  class << self

    def people
      find(:all, :conditions => ["is_organization = ?", false])
    end

    def volunteers
      find_by_type('volunteer')
    end

    def find_by_type(type)
      sql = "SELECT contacts.* FROM contacts
                 LEFT JOIN contact_types_contacts AS j ON j.contact_id = contacts.id
                 LEFT JOIN contact_types AS c_t ON j.contact_type_id = c_t.id
               WHERE c_t.description = ? "
      find_by_sql([sql, type])
    end

    def organizations
      find(:all, :conditions => ["is_organization = ?", true])
    end

    def search(query, options = {})
      # if the user added query wildcards or search metaterms, leave
      # be if not, assume it's better to bracket each word with
      # wildcards and join with ANDs.
      query = prepare_query(query)
      find_by_contents( query, options )
    end

    def search_by_type(type, query, options = {})
      query = prepare_query(query)
      query += " AND types:\"*#{type}*\""
      search(query, options)
    end

    protected

    def prepare_query(q)
      unless q =~ /\*|\~| AND| OR/
        q = q.split.map do |word|
          "*#{word}*" 
        end.join(' AND ')
      end
      q
    end

  end # class << self

  acts_as_ferret :fields => {
    'first_name' => {:boost => 2},
    'middle_name' => {},
    'surname' => {:boost => 2.5},
    'organization' => {:boost => 2},
    'types' => {:boost => 0}
  }

end
