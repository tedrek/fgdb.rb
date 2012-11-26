class SpecSheetQuestion < ActiveRecord::Base
  validates_uniqueness_of :position
  has_many :spec_sheet_question_conditions

  before_save :set_position_if_nil

  def set_position_if_nil
    self.position = SpecSheetQuestion.maximum(:position) + 1 if self.position.nil?
  end

  default_scope :order => 'position ASC'

  def real_name
    self.name.downcase.gsub(/ /, "_")
  end

  def self.find_relevant(action_id, type_id)
    (self.find_all_by_action_id_and_type_id(nil, type_id) +
    self.find_all_by_action_id_and_type_id(action_id, nil) +
    self.find_all_by_action_id_and_type_id(action_id, type_id)).uniq
  end
end
