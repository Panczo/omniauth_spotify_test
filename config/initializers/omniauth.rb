Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret, scope: 'playlist-read-private user-read-private user-read-email user-library-read'
end