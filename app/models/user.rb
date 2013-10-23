class User < ActiveRecord::Base
  has_many :friendships, 
    foreign_key: 'user_id', 
    class_name: 'Friendship',
    dependent: :destroy
  has_many :friends, through: :friendships
  
  has_many :befriendships, 
    foreign_key: 'friend_id', 
    class_name: 'Friendship',
    dependent: :destroy
  
  validates :name, :email, :password, :role, presence: true
  
  attr_accessor :password_confirmation
  validates_confirmation_of :password
end
