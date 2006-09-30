class Gizmo
  # some intended to be overridden
  # much of this is illegal or pseudo code

  # increment some tally bucket class/object
  def self.add(bucket,count,*args)
    bucket.add(count)
  end
  # decrement some tally bucket class/object
  def self.subtract(bucket,count,*args)
    bucket ||= Gizmo::Tally.new
    bucket.subtract(count)
  end

end
