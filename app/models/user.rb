class User < ActiveRecord::Base
  # Friendship relationships
  has_many :friendships, 
    foreign_key: 'user_id', 
    class_name: 'Friendship',
    dependent: :destroy
  has_many :friends, through: :friendships
  has_many :befriendships, 
    foreign_key: 'friend_id', 
    class_name: 'Friendship',
    dependent: :destroy
  
  # Other relationships
  has_many :participants
  
  # Validations
  validates :name, :password, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i } # From RailsGuides
  def self.valid_roles
    %w(admin user)
  end
  validates :role, presence: true, inclusion: { in: valid_roles, message: "'%{value}' is not a valid role" }
  validates_confirmation_of :password
end
