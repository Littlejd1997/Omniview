json.array!(@periscopes) do |periscope|
  json.extract! periscope, :id, :twitterhandle, :broadcast_id
  json.url periscope_url(periscope, format: :json)
end
