class WorkShiftFootnote < ActiveRecord::Base
  def self.add_to_footnote(date, message)
    note = self.find_or_create_by_date(date)
    note.note ||= ""
    note.note += "\n" if note.note.length > 0
    note.note += message
    note.save
    return note
  end
end
