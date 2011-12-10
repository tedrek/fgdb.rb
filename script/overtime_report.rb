#!/usr/bin/env ruby

#ENV['RAILS_ENV']||="production"

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

d = Date.today
while d.wday != 1
  d -= 1
end # find the monday of this week
d -= 7 # jump to the previous week
date_conds = [[d -7, d-1], [d, d+6]] # get that previous week and the week before
data = ""
data += "== Overtime Report ==\n"
date_conds.each {|start, fin|
  data +=  "\n"
  data +=  "Overtime for week of #{start.strftime("%D")}-#{fin.strftime("%D")}:\n"
  DB.execute(["SELECT workers.name AS worker, workers.ceiling_hours AS ceiling, SUM( duration ) AS actual from worked_shifts JOIN workers ON worked_shifts.worker_id = workers.id WHERE date_performed >= ? AND date_performed <= ? group by 1,2 having SUM( duration ) > workers.ceiling_hours ORDER BY 1;", start, fin]).each{|x|
    data +=  "#{x["worker"]}, who's ceiling is #{x["ceiling"]} worked #{x["actual"]} hours\n"
  }
}
Notifier.deliver_text_report("hr_mailing_list", "Overtime Report", data)
