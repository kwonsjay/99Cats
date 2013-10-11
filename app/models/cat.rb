class Cat < ActiveRecord::Base
  attr_accessible :age, :birth_date, :color, :name, :sex
  validates :age, :birth_date, :color, :name, :sex, :user_id, :presence => true
  validates :age, numericality: { only_integer: true }

  def self.available_colors
    ["black", "white", "calico", "red"]
  end

  validates :color, inclusion: { in: Cat.available_colors,
      message: "%{value} is not a valid color" }

  validates :sex, inclusion: { in: %w(m f),
      message: "%{value} is not a valid gender" }

  before_validation do
    self.color.downcase!
    self.sex.downcase!
  end

  has_many :rental_requests,
           :class_name => "CatRentalRequest",
           :primary_key => :id,
           :foreign_key => :cat_id,
           :dependent => :destroy

  belongs_to :user
end
