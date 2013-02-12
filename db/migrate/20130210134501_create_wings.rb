class CreateWings < ActiveRecord::Migration
  def change
    create_table :wings do |t|
      t.string :name
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
