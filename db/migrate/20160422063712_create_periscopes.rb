class CreatePeriscopes < ActiveRecord::Migration
  def change
    create_table :periscopes do |t|
      t.string :twitterhandle
      t.string :broadcast_id
      t.string :title
      t.timestamps null: false
    end
    add_index :periscopes, :broadcast_id, unique: true
  end
end
