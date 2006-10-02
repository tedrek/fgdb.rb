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

  # acts_as_userstamp

  def is_organization?
    self.is_organization
  end

  def is_person?
    ! self.is_organization?
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

  def relationships
    (relationships_as_source + relationships_as_sink).uniq
  end

  class << self

    def people
      find(:all, :conditions => ["is_organization = ?", false])
    end

    def organizations
      find(:all, :conditions => ["is_organization = ?", true])
    end

  end

end
