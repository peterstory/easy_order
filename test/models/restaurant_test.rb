require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
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
  
end
