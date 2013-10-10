class Cat < ActiveRecord::Base
  attr_accessible :age, :birth_date, :color, :name, :sex
  validates :age, :birth_date, :color, :name, :sex, :presence => true
  validates :age, numericality: { only_integer: true }

  validates :color, inclusion: { in: %w(black white calico red),
      message: "%{value} is not a valid color" }

  validates :sex, inclusion: { in: %w(m f),
      message: "%{value} is not a valid gender" }

  has_many :rental_requests,
           :class_name => "CatRentalRequest",
           :primary_key => :id,
           :foreign_key => :cat_id,
           :dependent => :destroy
end
