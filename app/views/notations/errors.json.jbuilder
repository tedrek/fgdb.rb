json.error true
json.messages @notation.errors do |k|
  json.column k
  json.errors @notation.errors[k]
end
