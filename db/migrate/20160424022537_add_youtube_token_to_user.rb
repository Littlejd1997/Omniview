class AddYoutubeTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :yttoken, :string
  end
end
