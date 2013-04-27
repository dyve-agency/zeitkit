json.ignore_nil! false
json.array! @worklogs do |worklog|
  json.id                    worklog.id
  json.client_id             worklog.client_id
  json.invoice_id            worklog.invoice_id

  json.start_time            worklog.start_time
  json.end_time              worklog.end_time

  json.start_time_unixtime   worklog.start_time.to_unixtime
  json.end_time_unixtime     worklog.end_time.to_unixtime

  json.summary               worklog.summary
  json.hourly_rate_cents     worklog.hourly_rate_cents
  json.total_cents           worklog.total_cents

  json.created_at            worklog.created_at
  json.updated_at            worklog.updated_at
  json.deleted_at            worklog.deleted_at

  json.created_at_unixtime   worklog.created_at.to_unixtime
  json.updated_at_unixtime   worklog.updated_at.to_unixtime
  json.deleted_at_unixtime   worklog.deleted_at.to_unixtime
end
