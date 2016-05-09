class RefreshFacebookToken < ActiveJob::Base
  queue_as :default

  def perform
    User.where.not(fbexpires: nil).each do |user|
      unless user.fbexpires.between?(Date.today, Date.today+5.hours)
        return
      end
      new_token = $fboauth.exchange_access_token_info(user.fbtoken)
      # Save the new token and its expiry over the old one
      user.fbtoken= new_token['access_token']
      user.fbexpires = Time.now+new_token['expires'].to_i
      user.save
    end
    RefreshFacebookToken.set(wait:1.hour).perform_later
  end
end
