class Shift < ActiveRecord::Base
  belongs_to :job, :include => [:coverage_type]
  belongs_to :weekday
  belongs_to :worker
  belongs_to :coverage_type

  def display_name
    s = " (" + self.schedule.name + ")" if self.schedule.name != "main" #FIXME
    s ||= ""
    self.name + s
  end

    def skedj_style(overlap, last)
      shift_style = ""
      if self.type == 'Meeting'
        shift_style = 'meeting'
      elsif self.type == 'Unavailability'
        shift_style = 'unavailable'
      elsif self.worker_id == 0
        shift_style = 'unfilled'
      elsif overlap
        # can't seem to get this part quite right
        # i expect a stupid syntax error
        # what should happen:
        # two overlapping anchored shifts should result 
        #   in hardconflict
        # two overlapping shifts where only one is anchored 
        #   should result in mediumconflict
        # other overlapping shifts should result in 
        #   softconflict
        # can't figure out if a shift is anchored?
        #   pretend it is anchored
        if (last.coverage_type ? last.coverage_type.name : 'anchored') == 'anchored'
          if not self.coverage_type
            shift_style = 'hardconflict'
          elsif self.coverage_type.name == 'anchored'
            shift_style = 'hardconflict'
          else
            shift_style = 'mediumconflict'
          end
        elsif self.coverage_type.name == 'anchored'
          shift_style = 'mediumconflict'
        else
          shift_style = 'softconflict'
        end
        # end of problem code
      else
        shift_style = 'shift'
      end
      return shift_style
    end
end
