require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  setup do
    @restaurant = restaurants(:valid)
    @invalid_restaurant = restaurants(:invalid)
  end
  
  test "known good restaurant should validate" do
    assert @restaurant.valid?
  end
  
  test "known bad restaurant should not validate" do
    assert @invalid_restaurant.invalid?
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
    # Mess with a known good restaurant
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
    
    restaurant.delivery_charge = nil
    assert restaurant.valid?
    assert restaurant.errors[:delivery_charge].none?, "blank delivery_charge should be allowed"
  end
  
  test "restaurant cuisine attribute must be valid" do
    # Mess with the known good restaurant
    restaurant = Restaurant.new ({ city: @restaurant.city, cuisine: @restaurant.cuisine,
                                   delivers: @restaurant.delivers,
                                   delivery_charge: @restaurant.delivery_charge, 
                                   description: @restaurant.description, 
                                   name: @restaurant.name, phone: @restaurant.phone, 
                                   state: @restaurant.state, street1: @restaurant.street1, 
                                   url: @restaurant.url, zipcode: @restaurant.zipcode })
    assert restaurant.valid?
    
    # Make sure there are valid cuisine types to choose from
    assert Restaurant.valid_cuisines, "no valid cuisines available"
    assert Restaurant.valid_cuisines.length > 0, "no valid cuisines available"
    
    # Make sure the valid cuisines are accepted
    Restaurant.valid_cuisines.each do |cuisine|
      restaurant.cuisine = cuisine
      assert restaurant.valid?, "valid cuisine '#{restaurant.cuisine}' should be accepted"
    end
  end
  
  test "restaurant state attribute must be of length 2" do
    # Mess with the known good restaurant
    restaurant = Restaurant.new ({ city: @restaurant.city, cuisine: @restaurant.cuisine,
                                   delivers: @restaurant.delivers,
                                   delivery_charge: @restaurant.delivery_charge, 
                                   description: @restaurant.description, 
                                   name: @restaurant.name, phone: @restaurant.phone, 
                                   state: @restaurant.state, street1: @restaurant.street1, 
                                   url: @restaurant.url, zipcode: @restaurant.zipcode })
    assert restaurant.valid?
    
    # A too short state abbreviation should fail
    restaurant.state = "Z"
    assert restaurant.invalid?
    assert restaurant.errors[:state].any?, "state abbreviation is too short"
    
    # A too long state abbreviation should fail
    restaurant.state = "USA"
    assert restaurant.invalid?
    assert restaurant.errors[:state].any?, "state abbreviation is too long"
  end
  
end
