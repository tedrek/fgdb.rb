class Contact < ActiveRecord::Base
  acts_as_userstamp

  has_and_belongs_to_many :contact_types
  has_many :contact_methods
  has_many :contact_method_types, :through => :contact_methods
  has_many :donations
  has_many :volunteer_tasks, :order => 'date_performed DESC'
  has_one :user

  validates_presence_of :postal_code
  #validates_presence_of :created_by
  before_save :remove_empty_contact_methods
  before_save :ensure_consistent_contact_types

  def is_organization?
    self.is_organization
  end

  def is_person?
    ! self.is_organization?
  end

  def uncompleted
    vt = volunteer_tasks.find_by_duration(nil)
    if not vt.nil? and vt.date_performed < 1.day.ago
      # evidentally they forgot to check out... make a new handler for this later.
      vt.destroy
      return nil
    else
      return vt
    end
  end

  def checked_in?
    not uncompleted.nil?
  end

  def check(options = {})
    if checked_in?
      task = uncompleted
      # since multiparameter attributes won't work w/ aliases, do it manually
      time_attrs = []
      for i in 1..5
        time_attrs << options.delete("end_time(#{i}i)").to_i
      end
      options[:end_time] = Time.local(*time_attrs)
      task.update_attributes(options)
    else
      task = VolunteerTask.new(options)
      volunteer_tasks << task
      task.save
    end
    return task
  end

  def hours_actual(last_ninety = false)
    tasks = last_ninety ? last_ninety_days_of_volunteer_tasks : volunteer_tasks
    tasks.inject(0.0) do |total,task|
      total += task.duration
    end
  end

  def find_volunteer_tasks(cutoff = nil)
    # if it's named volunteer_tasks it breaks everything
    if cutoff
      conditions = [ "contact_id = ? AND date_performed >= ?", id, cutoff ]
    else
      conditions = [ "contact_id = ?", id ]
    end
    VolunteerTask.find(:all,
                       :conditions => conditions)
  end

  def hours_effective
    find_volunteer_tasks(Date.today - 365).inject(0.0) do |total,task|
      unless task.type_of_task?('build')
        total += task.effective_duration
      end
      total
    end
  end

  # effective for adoption
  def adoption_hours
    hours_effective
  end

  def effective_discount_hours
    last_ninety_days_of_effective_hours
  end

  def last_ninety_days_of_volunteer_tasks
    find_volunteer_tasks(Date.today - 90)
  end

  def last_ninety_days_of_actual_hours
    hours_actual(true)
  end

  def last_ninety_days_of_effective_hours
    last_ninety_days_of_volunteer_tasks.inject(0.0) {|tot,task|
      tot + task.effective_duration
    }
  end

  def last_few_volunteer_tasks
    volunteer_tasks.sort_by {|v_t| v_t.date_performed }[-3..-1]
  end

  def default_volunteer_task_type
    last_few = last_few_volunteer_tasks
    if( last_few.length > 1 and
          last_few.map {|v_t| v_t.volunteer_task_type}.uniq.length == 1 )
      return last_few.first.volunteer_task_type
    else
      return []
    end
  end

  def screen_sortby
    display_name
  end

  def display_name
    if is_person?
      if(self.first_name || self.middle_name || self.surname)
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

  def short_address
    [address, extra_address, postal_code].join(', ')
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

  def types
    contact_types.join(' ')
  end

  def last_donation
    #:MC: optimize this into sql
    donations.sort_by {|don| don.created_at}.last
  end

  def default_discount_schedule
    if effective_discount_hours >= 4.0
      DiscountSchedule.find_by_name("volunteer")
    else
      DiscountSchedule.find_by_name("no discount")
    end
  end

  def is_user?
    !!user
  end

  def is_user=(x)
  end

  alias :is_user :is_user?

  private

  def remove_empty_contact_methods
    for contact_method in contact_methods
      if contact_method.description.nil? or contact_method.description.empty?
        contact_method.destroy
      end
    end
  end

  def ensure_consistent_contact_types
    types = contact_types.map {|ct| ct.description}
    if((types.include?("build") or types.include?("adopter")) and
       (! types.include?("volunteer")))
      contact_types << ContactType.find_by_description("volunteer")
    end
  end

  class << self
    # not ever used...but could be useful so I'm leaving it
    def find_by_type(type)
      sql = "SELECT contacts.* FROM contacts
                 LEFT JOIN contact_types_contacts AS j ON j.contact_id = contacts.id
                 LEFT JOIN contact_types AS c_t ON j.contact_type_id = c_t.id
               WHERE c_t.description = ? "
      find_by_sql([sql, type])
    end

    def search(query, options = {})
      # if the user added query wildcards or search metaterms, leave
      # be if not, assume it's better to bracket each word with
      # wildcards and join with ANDs.
      return [] unless query and query.length > 0
      conditions = prepare_query(query)
      find(:all, {:limit => 5, :conditions => conditions}.merge(options))
    end

    def search_by_type(type, query, options = {})
      if query.to_i.to_s == query
        # allow searches by id
        search(query, options)
      else
        query = prepare_query(query)
        query += " AND types:\"*#{type}*\""
        search(query, options)
      end
    end

    protected

    def prepare_query(q)
      if q.to_i.to_s == q
        return ["id = ?", q]
      end
      conds = [""]
      q.split.each do |word|
        conds[0] += "(surname ILIKE ? OR first_name ILIKE ? OR middle_name ILIKE ? OR organization ILIKE ?)"
        conds += ["%#{word}%"] * 4
        conds[0] += ' AND '
      end
      conds[0].sub!(/ AND $/, '')
      return conds
    end

    end # class << self

end
