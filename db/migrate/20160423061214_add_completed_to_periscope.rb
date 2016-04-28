class AddCompletedToPeriscope < ActiveRecord::Migration
  def change
    add_column :periscopes, :completed, :boolean, default: :f
    add_column :periscopes, :pending, :boolean, default: :f
  end
end
