json.id check.id
json.drive '/api/drives/' + check.drive.id.to_s
json.run '/api/runs/' + check.run.id.to_s
json.check_code check.check_code
json.check_name check.check_name
json.passed check.passed
json.sequence_num check.sequence_num
json.status check.status
json.start_time check.start_time.iso8601
json.end_time check.end_time.iso8601
json.attachments check.attachments do |f|
  json.name f.name
  json.url '/attachments/' + f.id.to_s
end
