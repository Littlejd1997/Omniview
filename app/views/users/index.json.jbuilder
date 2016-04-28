json.array!(@users) do |user|
  json.extract! user, :id, :twitterhandle
  json.url user_url(user, format: :json)
end
