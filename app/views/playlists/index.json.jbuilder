json.array!(@playlists) do |playlist|
  json.extract! playlist, :id, :name, :references
  json.url playlist_url(playlist, format: :json)
end
