class FetchPeriscopes < ActiveJob::Base
  queue_as :default

  def perform(user)
    begin
      return if (user.nil? || user.empty?)
      # Periscope.where.not(created_at: 24.hours.ago..Time.now).destroy_all
      $twitter.user_timeline(user, {count: 3200}).keep_if do |tweet|
        tweet.source.include?("periscope") && (tweet.created_at >= 20.hours.ago)
      end.each do |tweet|
        p = Periscope.new
        p.createFromTweet(tweet)
        begin
          p.save
        rescue ActiveRecord::RecordNotUnique
        end
      end
      Periscope.all.where({pending: false, completed: false}).each do |periscope|
        periscope.pending = true;
        periscope.save
        TranscodePeriscope.perform_later(periscope);
      end
      FetchPeriscopes.set(wait: 1.minute).perform_later(user)
    end
  rescue
  end


end
