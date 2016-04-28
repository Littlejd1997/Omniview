class AddYoutubeToPeriscopes < ActiveRecord::Migration
  def change
    add_reference :periscopes, :youtube, index: true, foreign_key: true
  end
end
