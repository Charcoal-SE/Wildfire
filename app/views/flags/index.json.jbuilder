json.array!(@flags) do |flag|
  json.extract! flag, :id, :id, :completed, :failure_reason, :attempted_at
  json.url flag_url(flag, format: :json)
end
