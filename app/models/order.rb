class Order < ActiveRecord::Base
  self.inheritance_column = nil  # Allow column named :type

  has_many :participants
  has_many :participating_users, through: :participants
  
  belongs_to :restaurant
  validates :restaurant, presence: true
  belongs_to :organizer, :class_name => 'User'
  validates :organizer, presence: true
  
  def self.valid_types
    %w(delivery pick-up)
  end
  validates :type, inclusion: { in: valid_types }
  
  validates :total, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  
  def self.valid_statuses
    %w(pending placed)
  end
  validates :status, inclusion: { in: valid_statuses }
  
  validates :placed_at, presence: true
end
