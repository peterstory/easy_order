class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :participating_user, class_name: 'User', foreign_key: 'user_id'  # Same as above, clearly named
  belongs_to :order
  has_many :line_items
  
  #validates :order, presence: true  # Won't work, since an order is created after its participants
  validates :user, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  def self.valid_roles
    %w(organizer participant)
  end
  validates :role, presence: true, inclusion: { in: valid_roles, message: "'%{value}' is not a valid role" }
  
end
