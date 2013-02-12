class Wing < ActiveRecord::Base
  attr_accessible :description, :image, :name
  has_many :rooms

  validates :name, :presence => true
end
