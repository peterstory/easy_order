class Restaurant < ActiveRecord::Base
  validates :name, :cuisine, :street1, :city, :state, :zipcode, 
    :phone, :url, presence: true
  validates :state, length: { is: 2 }
end