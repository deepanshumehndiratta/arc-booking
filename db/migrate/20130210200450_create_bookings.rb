class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :room_id
      t.integer :user_id
      t.text :reason
      t.datetime :begin
      t.datetime :end
      t.boolean :projector
      t.string :approved
      t.string :projector_approved

      t.timestamps
    end
  end
end
