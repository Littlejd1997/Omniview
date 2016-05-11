class Periscope < ActiveRecord::Base
  has_one :user, primary_key: 'twitterhandle', foreign_key: 'twitterhandle'
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
        self.completed = false
        self.save
        return false
      end
      self.completed = system("echo -e #{generateffmpeg(periscopeAPI)};#{generateffmpeg(periscopeAPI)}");
      save
    rescue
      self.pending = false
      self.save
    end

    return self.completed
  end

  def getAPI

    uri = URI("https://api.periscope.tv/api/v2/getAccessPublic?token=#{broadcast_id}")
    periscopeAPI = JSON.parse!(Net::HTTP.get(uri))
  end
  def inProgress?
    periscopeAPI['type'] == "StreamTypeWeb"

  end

  def generateffmpeg(api)
    cookies = generateCookies(api)
    input = api['replay_url']
    orientation = ""
    orientation = '-vf "transpose=1"' if (self.user.defaultOrientation == 90)
    command = "ffmpeg -cookies \"#{cookies}\" -i \"#{input}\" -c:v libx264 -maxrate 500k -bufsize 150k -y  -c:a aac -strict -2 -threads 8 #{orientation}  #{broadcast_id}.mp4"
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

  def exportToFacebook
    unless File.exist?("#{broadcast_id}.mp4")
    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV["AWS_ID"], ENV["AWS_SECRET"]),
        region: 'us-east-1'
    )
    obj = s3.bucket('com.jschober.transcope').object("#{broadcast_id}.mp4")
    obj.get({response_target: "#{broadcast_id}.mp4"})
    end
    @graph = Koala::Facebook::API.new(self.user.fbtoken)
    @upload_graph = @graph
    unless user.pageid == -1
      page_token = @graph.get_page_access_token(user.pageid)
      @upload_graph = Koala::Facebook::API.new(page_token)
    end
    fbResponse = @upload_graph.put_video("#{broadcast_id}.mp4", {:title => self.title}, "me")
    self.facebookVideo = fbResponse["id"]
    self.save
  end
end