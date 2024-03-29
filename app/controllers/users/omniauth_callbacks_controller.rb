class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	  
  def spotify
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(omnia_hash)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Spotify") if is_navigational_format?
    else
      session["devise.spotify_data"] = omnia_hash
      redirect_to new_user_registration_url
    end
  end
  protected

  def omnia_hash
    request.env["omniauth.auth"]
  end
end