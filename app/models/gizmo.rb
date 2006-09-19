class Gizmo < ActiveRecord::Base
  belongs_to :class_tree

  # :MC: Yeah, let's override one of those core bits of functionality
  # and see what happens...
  # This allows all class-level finder methods to instantiate an
  # object of the correct class, as determined through the
  # class_tree.
  def Gizmo.instantiate(record)
    #:TODO:
    super(record)
  end

end
