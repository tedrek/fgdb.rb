class Default < ActiveRecord::Base
  class << self
    def [](name)
      return find_by_name(name).value
    rescue
      return nil
    end
  end
end
