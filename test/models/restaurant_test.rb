require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  setup do
    @restaurant = restaurants(:one)
  end
  
  test "restaurant attributes must not be empty" do
    restaurant = Restaurant.new
    assert restaurant.invalid?
    assert restaurant.errors[:name].any?, "name should be required"
    assert restaurant.errors[:cuisine].any?, "cuisine should be required"
    assert restaurant.errors[:street1].any?, "street1 should be required"
    assert restaurant.errors[:city].any?, "city should be required"
    assert restaurant.errors[:state].any?, "state should be required"
    assert restaurant.errors[:zipcode].any?, "zipcode should be required"
    assert restaurant.errors[:phone].any?, "phone should be required"
    assert restaurant.errors[:url].any?, "url should be required"
  end
  
  test "restaurant delivery_charge must be non-negative" do
    restaurant = Restaurant.new ({ city: @restaurant.city, cuisine: @restaurant.cuisine,
                                   delivers: true, 
                                   delivery_charge: -1, 
                                   description: @restaurant.description, 
                                   name: @restaurant.name, phone: @restaurant.phone, 
                                   state: @restaurant.state, street1: @restaurant.street1, 
                                   url: @restaurant.url, zipcode: @restaurant.zipcode })
    assert restaurant.invalid?
    assert restaurant.errors[:delivery_charge].any?, "delivery_charge >= 0 should be enforced"
    
    restaurant.delivery_charge = 0
    assert restaurant.valid?
    assert restaurant.errors[:delivery_charge].none?, "delivery_charge of 0 should be allowed"
    
    restaurant.delivery_charge = 1
    assert restaurant.valid?
    assert restaurant.errors[:delivery_charge].none?, "delivery_charge > 0 should be allowed"
  end
  
end
