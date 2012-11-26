class AddPositionToSpecSheetQuestions < ActiveRecord::Migration
  def self.up
    add_column :spec_sheet_questions, :position, :integer
    count = 0
    my_q_id = -1
    SpecSheetQuestion.find(:all, :order => 'id ASC').each do |q|
      if q.name == 'Cores per Processor'
        q.position = my_q_id
        raise if my_q_id == -1
      else
        q.position = count
        count += 1
        if q.name == "Current Processors"
          my_q_id = count
          count += 1
        end
      end
      q.save
    end
  end

  def self.down
    remove_column :spec_sheet_questions, :position
  end
end
