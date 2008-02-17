class Default < ActiveRecord::Base

  class << self
    def [](name)
      return find(:first, :conditions => ["name = ?", name]).value
    rescue
      return nil
    end
  end
end
