class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitterhandle
      t.string :firstname
      t.string :lastname
      t.string :bio
      t.timestamps null: false
    end
  end
end
