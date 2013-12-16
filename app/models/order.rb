class Order < ActiveRecord::Base
  self.inheritance_column = nil  # Allow column named :type

  has_many :participants, dependent: :destroy
  has_many :participating_users, through: :participants
  
  has_many :line_items
  
  belongs_to :restaurant
  validates :restaurant, presence: true
  belongs_to :organizer, :class_name => 'User'
  validates :organizer, presence: true
  
  def self.valid_types
    %w(delivery pick-up)
  end
  validates :type, presence: true, inclusion: { in: valid_types, message: "'%{value}' is not a valid delivery type" }
  
  validates :total, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  
  def self.valid_statuses
    %w(pending placed)
  end
  validates :status, presence: true, inclusion: { in: valid_statuses, message: "'%{value}' is not a valid status"  }
  
  validates :placed_at, presence: true
  
  def update_total
    recalculated_total = 0
    self.line_items.each do |line_item|
      recalculated_total += line_item.price
    end
    self.total = recalculated_total
    self.save
  end
end
