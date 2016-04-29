class RefreshFacebookToken < ActiveJob::Base
  queue_as :default

  def perform(user)
    new_token = $fboauth.exchange_access_token_info(user.fbtoken)

    # Save the new token and its expiry over the old one
    user.fbtoken= new_token['access_token']
    user.fbexpires = Time.now+new_token['expires'].to_i
    user.save
  end
end
