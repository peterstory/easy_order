class Restaurant < ActiveRecord::Base
  validates :name, :cuisine, :street1, :city, :state, :zipcode, 
    :phone, :url, presence: true
  
  def self.valid_cuisines
    %w(BBQ Chinese Italian Mexican Seafood)
  end
  validates :cuisine, inclusion: { in: valid_cuisines, message: "'%{value}' is not a valid cuisine" }
    
  validates :state, length: { is: 2 }
  validates :delivery_charge, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  
  has_many :orders
  
  has_one :menu
  accepts_nested_attributes_for :menu
  validates_associated :menu
end
