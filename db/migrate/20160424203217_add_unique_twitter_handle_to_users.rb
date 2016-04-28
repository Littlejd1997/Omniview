class AddUniqueTwitterHandleToUsers < ActiveRecord::Migration
  def change
    add_index :users, :twitterhandle, unique: true
  end
end
