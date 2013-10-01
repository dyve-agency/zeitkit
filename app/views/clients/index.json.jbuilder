json.ignore_nil! false
json.array! @clients do |client|
  json.id                    client.id

  json.name                  client.name
  json.hourly_rate_cents     client.hourly_rate_cents

  json.created_at            client.created_at
  json.updated_at            client.updated_at
  json.deleted_at            client.deleted_at

  json.created_at_unixtime   client.created_at.to_unixtime
  json.updated_at_unixtime   client.updated_at.to_unixtime
  json.deleted_at_unixtime   client.deleted_at.to_unixtime
end
