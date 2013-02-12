class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :wing_id
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
