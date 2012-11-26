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
    remove_column :schedules, :parent_id
    remove_column :schedules, :lft
    remove_column :schedules, :rgt
  end

  def self.down
    remove_column :shifts, :week
  end
end
