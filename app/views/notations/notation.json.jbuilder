json.id @notation.id
json.contact @notation.contact_id
json.author "%s %s" % [@notation.contact.first_name, @notation.contact.surname]
json.content @notation.content
json.notatable_id   @notation.notatable_id
json.notatable_type @notation.notatable_type
