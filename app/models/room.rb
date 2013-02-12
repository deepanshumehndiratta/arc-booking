class Room < ActiveRecord::Base
  attr_accessible :description, :image, :name, :wing_id
  has_many :bookings
  belongs_to :wing

  validates :name, :presence => true
  validates :wing_id, :presence => true

  validate :booking_room_validity

  def booking_room_validity
    if !wing_id || !Wing.exists?(wing_id)
      errors.add(:room_id, "Please choose an Appropriate Wing for the Room.")
    end
  end
end
