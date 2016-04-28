class AddFbTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fbtoken, :string
    add_column :users, :fbexpires, :datetime
  end
end
