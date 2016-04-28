class AddPageIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :pageid, :integer
  end
end
