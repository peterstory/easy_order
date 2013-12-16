class Participant < ActiveRecord::Base
  
  # Set default value of "participant"
  after_initialize do
    if self.new_record?
      self.role = "participant"
    end
  end

  belongs_to :user
  belongs_to :participating_user, class_name: 'User', foreign_key: 'user_id'  # Same as above, clearly named
  belongs_to :order
  has_many :line_items, dependent: :destroy
  
  #validates :order, presence: true  # Won't work, since an order is created after its participants
  validates :user, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  def self.valid_roles
    %w(organizer participant)
  end
  validates :role, presence: true, inclusion: { in: valid_roles, message: "'%{value}' is not a valid role" }
  
  def update_total
    recalculated_total = 0
    self.line_items.each do |line_item|
      recalculated_total += line_item.price
    end
    self.total = recalculated_total
    self.save
  end
  
end
