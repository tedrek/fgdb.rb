#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def handle_holiday(holiday, num_weeks)
  return unless holiday
  if Holiday.find_by_holiday_date_and_name(holiday.holiday_date - 1, holiday.name)
    return # we alerted them on the first day
  end
  i = 1
  while Holiday.find_by_holiday_date_and_name(holiday.holiday_date + i, holiday.name)
    i += 1
  end
  subj = "Closed for #{holiday.name} (#{num_weeks} week reminder)"
  msg = "Free Geek will be closed #{holiday.is_all_day ? "" : "from #{holiday.start_time.strftime("%T")} to #{holiday.end_time.strftime("%T")} "}#{i == 1 ? "on" : "starting"} #{holiday.holiday_date} for #{i} day#{i == 1 ? "" : "s"} for the #{holiday.name} holiday."
  Notifier.deliver_holiday_announcement(subj, msg)
end

tod = Date.today
handle_holiday(Holiday.find_by_holiday_date(tod + 7), "one")
handle_holiday(Holiday.find_by_holiday_date(tod + 14), "two")
