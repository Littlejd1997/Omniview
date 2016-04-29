class AddFacebookVideoToPeriscope < ActiveRecord::Migration
  def change
    add_column :periscopes,:facebookVideo, :string
  end
end
