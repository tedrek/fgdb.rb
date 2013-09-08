class SkedMember < ActiveRecord::Base
  belongs_to :sked
  belongs_to :roster

  def promote
    transaction do
      SkedMember.where(:position => (position - 1)).each do |swap|
        swap.position = position
        swap.save!
      end
      self.position -= 1
      save!
    end
    self
  end

  def demote
    transaction do
      SkedMember.where(:position => (position + 1)).each do |swap|
        swap.position = position
        swap.save!
      end
      self.position += 1
      save!
    end
    self
  end
end
