require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:valid)
    @invalid_order = orders(:invalid)
  end
  
  test "known good order should validate" do
    assert @order.valid?
  end
  
  test "known bad order should not validate" do
    assert @invalid_order.invalid?
  end
  
  test "order attributes that must not be empty" do
    order = Order.new
    assert order.invalid?
    assert order.errors[:restaurant].any?, "restaurant should be required"
    assert order.errors[:organizer].any?, "organizer should be required"
    assert order.errors[:type].any?, "type should be required"
    assert order.errors[:status].any?, "status should be required"
    assert order.errors[:placed_at].any?, "placed_at should be required"
  end
  
  test "order attribute total must be non-negative" do
    # Mess with a known good order
    order = Order.new ({ restaurant_id: @order.restaurant_id, 
                         organizer_id: @order.organizer_id, type: @order.type, 
                         total: @order.total, status: @order.status, 
                         placed_at: @order.placed_at })
    assert order.valid?
    
    order.total = -1
    assert order.invalid?
    assert order.errors[:total].any?, "total >= 0 should be enforced"
    
    order.total = 0
    assert order.valid?
    assert order.errors[:total].none?, "total of 0 should be allowed"
    
    order.total = 1
    assert order.valid?
    assert order.errors[:total].none?, "total > 0 should be allowed"
    
    order.total = nil
    assert order.valid?
    assert order.errors[:total].none?, "blank total should be allowed"
  end
  
  test "order attribute type must be valid" do
    # Mess with a known good order
    order = Order.new ({ restaurant_id: @order.restaurant_id, 
                         organizer_id: @order.organizer_id, type: @order.type, 
                         total: @order.total, status: @order.status, 
                         placed_at: @order.placed_at })
    assert order.valid?
    
    # Make sure there are valid types to choose from
    assert Order.valid_types, "no valid types to choose from"
    assert Order.valid_types.length > 0, "no valid types to choose from"
    
    # Make sure the valid types are accepted
    Order.valid_types.each do |type|
      order.type = type
      assert order.valid?, "valid type '#{order.type}' should be accepted"
    end
  end
  
  test "order attribute status must be valid" do
    # Mess with a known good order
    order = Order.new ({ restaurant_id: @order.restaurant_id, 
                         organizer_id: @order.organizer_id, type: @order.type, 
                         total: @order.total, status: @order.status, 
                         placed_at: @order.placed_at })
    assert order.valid?
    
    # Make sure there are valid statuses to choose from
    assert Order.valid_statuses, "no valid statuses to choose from"
    assert Order.valid_statuses.length > 0, "no valid statuses to choose from"
    
    # Make sure the valid statuses are accepted
    Order.valid_statuses.each do |status|
      order.status = status
      assert order.valid?, "valid status '#{order.status}' should be accepted"
    end
  end
  
  test "order attribute organizer_id must correspond to an existing user" do
    # Mess with a known good order
    order = Order.new ({ restaurant_id: @order.restaurant_id, 
                         organizer_id: @order.organizer_id, type: @order.type, 
                         total: @order.total, status: @order.status, 
                         placed_at: @order.placed_at })
    assert order.valid?
    
    # Break the relationship, randomly
    order.organizer_id = rand(9999)
    assert order.invalid?
  end
  
  test "order attribute restaurant_id must correspond to an existing restaurant" do
    # Mess with a known good order
    order = Order.new ({ restaurant_id: @order.restaurant_id, 
                         organizer_id: @order.organizer_id, type: @order.type, 
                         total: @order.total, status: @order.status, 
                         placed_at: @order.placed_at })
    assert order.valid?
    
    # Break the relationship, randomly
    order.restaurant_id = rand(9999)
    assert order.invalid?
  end
end
