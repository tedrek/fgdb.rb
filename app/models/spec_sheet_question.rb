class SpecSheetQuestion < ActiveRecord::Base
  belongs_to :action
  belongs_to :type

  def self.find_relevant(action_id, type_id)
    (self.find_all_by_action_id_and_type_id(nil, type_id) +
    self.find_all_by_action_id_and_type_id(action_id, nil) +
    self.find_all_by_action_id_and_type_id(action_id, type_id)).uniq
  end
end
