class ContactType < ActiveRecord::Base

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
    def build
      lookup_by_description("build")
    end
    def adopter
      lookup_by_description("adopter")
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
