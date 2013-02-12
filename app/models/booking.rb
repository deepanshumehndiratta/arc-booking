class Booking < ActiveRecord::Base
  cattr_accessor :current_user
  attr_accessible :approved, :begin, :end, :projector, :projector_approved, :reason, :room_id, :user_id
  belongs_to :room

  validates :begin, :presence => true
  validates :end, :presence => true
  validates :projector, :inclusion => { :in => [true, false] }
  validates :reason, :presence => true
  validates :room_id, :presence => true
  validates :approved, :inclusion => { :in => ['YES', 'NO', 'PENDING'] }
  validates :projector_approved, :inclusion => { :in => ['YES', 'NO', 'PENDING'] }

  validate :booking_room_validity
  validate :time_validity

  def booking_room_validity
    if !room_id || !Room.exists?(room_id)
      errors.add(:room_id, "Please choose an Appropriate Room to book.")
    end
  end

  def time_validity
    if self[:begin] >= self[:end]
      errors.add(:end, "The Ending Time should be past the Beginning Time.")
    end
    if self[:begin] <= Time.current.to_s
      errors.add(:begin, "Please choose a booking time in the future.")
    end
    booking = Booking.find(:all, :conditions => ["((begin >= ? AND end >= ? AND begin <= ?) OR (begin >= ? AND end <= ?) OR (begin <= ? AND end >= ?) OR (begin >= ? AND end >= ?) OR (begin <= ? AND end <= ? AND end >= ?)) AND room_id = ? AND approved = 'YES'", self[:begin], self[:end], self[:end], self[:begin], self[:end], self[:begin], self[:end], self[:begin], self[:end], self[:begin], self[:end], self[:begin], room_id])
    puts booking.to_s
    if !booking.blank?
      if !((self.current_user.superadmin && self[:approved] == 'NO') || (self.current_user.projector_admin && self[:projector_approved] == 'NO'))
        errors.add(:begin, "The room is already booked between these intervals.")
        errors.add(:end, "The room is already booked between these intervals.")
      end
    end
  end
end
