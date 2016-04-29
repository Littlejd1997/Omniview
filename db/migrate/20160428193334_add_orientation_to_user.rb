class AddOrientationToUser < ActiveRecord::Migration
  def change
    add_column :users, :defaultOrientation, :integer, default: 0
  end
end
