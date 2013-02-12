class Wing < ActiveRecord::Base
  attr_accessible :description, :image, :name
  has_many :rooms
  mount_uploader :image, ImageUploader

  validates :name, :presence => true
end
