class TranscodePeriscope < ActiveJob::Base
  queue_as :default

  def perform(periscope)
    if `ps aux | grep ffmpeg[l]` != ""
      return
    end
    return false if (periscope.transcodePeriscope() == false)
    s3 = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(ENV["AWS_ID"], ENV["AWS_SECRET"]),
        region: 'us-east-1'
    )

    obj = s3.bucket('com.jschober.transcope').object("#{periscope.broadcast_id}.mp4")

    File.delete("#{periscope.broadcast_id}.mp4") if obj.upload_file("#{periscope.broadcast_id}.mp4", acl:'public-read')
    obj.public_url
    if (periscope.user.automaticExport)
     UploadToFacebook.perform_later(periscope)	
    end
  end

end
