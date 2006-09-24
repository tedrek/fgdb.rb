class ActiveRecord::Base

  def self.find_all_except(*recs)
    return find_all - recs
  end

  def self.find_all_instantiable
    find(:all, :conditions => [ 'instantiable = ?', true ])
  end

end
