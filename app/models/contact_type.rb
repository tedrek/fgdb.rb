class ContactType < ActiveRecord::Base
  usesguid

  validates_uniqueness_of :description, :message => "already exists"
  # acts_as_userstamp

  def to_s
    description
  end

  class << self
    def lookup_by_description(desc)
      find(:first, :conditions => ["description=?", desc])
    end

    def volunteer
      lookup_by_description("volunteer")
    end
    def builder
      lookup_by_description("builder")
    end
    def adoption
      lookup_by_description("adoption")
    end

  end

  def long_for_who
    case for_who
    when 'per'
      'person'
    when 'org'
      'organization'
    else
      for_who
    end
  end

end
