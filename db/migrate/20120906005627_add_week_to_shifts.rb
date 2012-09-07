class AddWeekToShifts < ActiveRecord::Migration
  def self.up
    add_column :shifts, :week, :character
    main = Schedule.find_by_name("main")
    if main && Default.is_pdx
      desc = Schedule.find_all_by_parent_id(main.id)
      from = desc.map(&:id)
      to = main.id
      for i in [:shifts, :standard_shifts, :holidays, :work_shifts]
        DB.exec(['UPDATE ' + i.to_s + ' SET schedule_id = ? WHERE schedule_id IN (?)', to, from])
      end
      desc.each(&:destroy)
    end
  end

  def self.down
  end
end
