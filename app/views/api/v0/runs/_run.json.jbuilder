json.id run.id
json.drive '/api/drives/' + run.drive.id.to_s
json.device_name run.device_name
json.start_time run.start_time.iso8601
json.end_time run.end_time.nil? ? nil : run.end_time.iso8601
json.result run.result
