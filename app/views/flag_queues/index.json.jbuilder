json.array!(@flag_queues) do |flag_queue|
  json.extract! flag_queue, :id, :name
  json.url flag_queue_url(flag_queue, format: :json)
end
