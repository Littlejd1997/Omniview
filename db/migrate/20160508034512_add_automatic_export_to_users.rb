class AddAutomaticExportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :automaticExport, :boolean
  end
end
