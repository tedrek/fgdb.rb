class ActiveRecord::Base

  def self.find_all_except(*recs)
    return find_all - recs
  end

end
