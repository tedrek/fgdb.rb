#!/usr/bin/env ruby


#ENV['RAILS_ENV']||="production"

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

hours_logged_since = Date.today - 1 # runs after midnight, checks for that previous day
max = hours_logged_since + 1

fmt = "%-10s | %-15s | %11s | %11s\n"
report = ""
results = DB.exec(["SELECT DISTINCT date_performed, worker_id FROM worked_shifts WHERE job_id IS NOT NULL AND ((created_at > ? AND created_at < ?) OR (updated_at > ? AND updated_at < ?)) ORDER BY 1,2;", hours_logged_since, max, hours_logged_since, max]).to_a
report += (fmt % ["Date", "Worker", "Total Hours", "Break Hours"])
report += "--------------------------------------------------------\n"
results.each{|x|
  d , w = x["date_performed"], x["worker_id"]
  if ! Worker.find_by_id(x["worker_id"]).salaried
    list = WorkedShift.find_all_by_date_performed_and_worker_id(d, w)
    t = 0.0
    b = 0.0
    list.each{|y|
      if y.job.name == 'Paid Break'
        b += y.duration
      else
        t += y.duration
      end
      w = y.worker
    }
    report += (fmt % [d, w.name, t.to_s, b.to_s])
  end
}
#puts report # debug
Notifier.deliver_text_report("management_mailing_list", "Report of staff breaks logged yesterday", report)
