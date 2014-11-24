class User < ActiveRecord::Base
  serialize :spotify_hash
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:spotify]

  has_many :playlists

  after_save :import_playlists


  def self.from_omniauth(auth)
    spotify_user = RSpotify::User.new(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.name = auth.info.name   # assuming the user model has a name
          user.image = auth.info.image # assuming the user model has an image
          user.spotify_hash = spotify_user.to_hash
        end
	end


	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.spotify_data"] && session["devise.spotify_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end


  private

  def import_playlists
    spotify_user = RSpotify::User.new(spotify_hash)
    playlists = spotify_user.playlists
    playlists.each do |playlist|
      Playlist.create(user_id: id, name: playlist.name)
    end
  end
end
