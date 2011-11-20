#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def send_mail(subj, msg)
  puts "TODO: send this to paidworkers from fgdb"
  puts "== #{subj} =="
  puts msg
end

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
  msg = "Free Geek will be closed #{i == 1 ? "on" : "starting"} #{holiday.holiday_date} for #{i} day#{i == 1 ? "" : "s"} for the #{holiday.name} holiday."
  blah = ["Be sure to update:", " * the phone system message (http://wiki.freegeek.org/index.php/Changing_the_Phone_Greetings)", " * the main website", " * social media websites (Twitter, Facebook, etc)", " * anywhere else people might expect to find this information"].join("\n")
  msg += "\n\n" + blah
  send_mail(subj, msg)
end

tod = Date.today - 1
handle_holiday(Holiday.find_by_holiday_date(tod + 7), "one")
handle_holiday(Holiday.find_by_holiday_date(tod + 14), "two")
