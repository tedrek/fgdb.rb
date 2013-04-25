#!/usr/bin/ruby

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

# from, to, multiples of
range = [80, 150, 10]
times = [
[:Six_Month, '2012-10-01', '2013-04-01', 6],
[:Year_2012, '2012-01-01', '2013-01-01', 12],
[:Q1_2011, '2011-01-01', '2011-04-01', 3],
[:Q2_2011, '2011-04-01', '2011-07-01', 3],
[:Q3_2011, '2011-07-01', '2011-10-01', 3],
[:Q4_2011, '2011-10-01', '2012-01-01', 3],
[:Q1_2012, '2012-01-01', '2012-04-01', 3],
[:Q2_2012, '2012-04-01', '2012-07-01', 3],
[:Q3_2012, '2012-07-01', '2012-10-01', 3],
[:Q4_2012, '2012-10-01', '2013-01-01', 3],
[:Q1_2013, '2013-01-01', '2013-04-01', 3],
[:Jan, '2013-01-01', '2013-02-01', 1],
[:Feb, '2013-02-01', '2013-03-01', 1],
[:Mar, '2013-03-01', '2013-04-01', 1],
[:Apr, '2013-04-01', '2013-05-01', 1],
]

@range_query = (range[0]..range[1]).to_a.select{|x| x % range[2] == 0}.map{|x| "SELECT #{x} AS first"}.join(" UNION ALL ")

def run_query(name, first, last, number)
  puts "== #{name}: #{first} - #{last} =="
  DB.exec("SELECT f.first, COUNT(*) FROM contacts JOIN (#{@range_query}) AS f ON COALESCE((SELECT SUM(duration) FROM volunteer_tasks WHERE created_at < '#{first}' AND contact_id = contacts.id) < f.first, 't') AND COALESCE((SELECT SUM(duration) FROM volunteer_tasks WHERE created_at < '#{last}' AND contact_id = contacts.id) >= f.first, 'f') GROUP BY 1;").map{|x| [x["first"].to_i, x["count"].to_i / number.to_f]}.sort_by(&:first).each do |milestone, count|
    puts "Average of #{count} contacts reached #{milestone} hours each month (of #{number}) in range"
  end
end

times.each do |a|
  run_query(*a)
end
