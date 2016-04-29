class UploadToFacebook < ActiveJob::Base
  queue_as :default

  def perform(periscope)
    periscope.exportToFacebook
  end

end
