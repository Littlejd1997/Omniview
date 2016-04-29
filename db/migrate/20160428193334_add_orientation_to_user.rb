class AddOrientationToUser < ActiveRecord::Migration
  def change
    add_column :users, :defaultOrientation, :integer
  end
end
