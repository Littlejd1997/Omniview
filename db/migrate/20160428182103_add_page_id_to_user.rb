class AddPageIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :pageid, :string
  end
end
