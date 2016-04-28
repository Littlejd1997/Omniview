class Periscope < ActiveRecord::Base
  def createFromTweet(tweet)
    self.twitterhandle = tweet.user.screen_name.downcase
    self.broadcast_id = tweet.uris.first.expanded_url.to_s.split('/w/')[1]
    begin
      self.title = tweet.full_text.split("#Periscope: ")[1].split("http")[0]
    rescue
      self.title = "Untitled"
    end
  end

  def transcodePeriscope
    begin
      periscopeAPI = getAPI
      unless periscopeAPI['type'] == "StreamTypeReplay"
        self.pending = false
        self.save
        self.completed = false
        return false
      end
      self.completed = system("echo -e #{generateffmpeg(periscopeAPI)};#{generateffmpeg(periscopeAPI)}");
      save
    rescue
      self.pending = false
      save
    end

    return self.completed
  end

  def getAPI

    uri = URI("https://api.periscope.tv/api/v2/getAccessPublic?token=#{broadcast_id}")
    periscopeAPI = JSON.parse!(Net::HTTP.get(uri))
  end

  def generateffmpeg(api)
    cookies = generateCookies(api)
    input = api['replay_url']
    command = "ffmpeg -cookies \"#{cookies}\" -i \"#{input}\" c:v libx264 -maxrate 500k -bufsize 150k -y  -c:a aac -strict -2 -threads 8   #{broadcast_id}.mp4"
    Rails.logger.info(command)
    return command
  end

  def generateCookies(api)
    cookies = ""
    api["cookies"].each do |cookie|
      cookies += "#{cookie["Name"]}=#{cookie["Value"]};path=/; domain=.periscope.tv; "
      cookies += "\r\n"
    end
    return cookies
  end

  def exportToFacebook(token)
    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV["AWS_ID"], ENV["AWS_SECRET"]),
        region: 'us-east-1'
    )
    obj = s3.bucket('com.jschober.transcope').object("#{broadcast_id}.mp4")
    obj.get({response_target: "#{broadcast_id}.mp4"})
    @graph = Koala::Facebook::API.new(token)
    @graph.put_video("#{broadcast_id}.mp4", {:title => self.title}, "me")
  end
end