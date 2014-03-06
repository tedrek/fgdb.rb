json.id attachment.id
json.name attachment.name
json.content_type attachment.content_type
json.set! :attachable do
  json.id attachment.attachable.id
  json.type attachment.attachable.class.name
end
json.url '/api/attachments/' + attachment.id.to_s + '/data'
