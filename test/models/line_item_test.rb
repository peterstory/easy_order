require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  setup do
    @line_item = line_items(:valid)
    @invalid_line_item = line_items(:invalid)
  end
  
  test "known good line_item should validate" do
    assert @line_item.valid?
  end
  
  test "known bad line_item should not validate" do
    assert @invalid_line_item.invalid?
  end
  
  test "line_item attributes must not be empty" do
    line_item = LineItem.new
    assert line_item.invalid?
    assert line_item.errors[:participant].any?, "valid participant should be required"
    assert line_item.errors[:order].any?, "valid order should be required"
    assert line_item.errors[:name].any?, "name should be required"
    assert line_item.errors[:price].any?, "price should be required"
    assert line_item.errors[:notes].none?, "empty notes should be allowed"
  end
  
  test "line_item attribute participant_id must correspond to an existing participant" do
    # Mess with a known good line_item
    line_item = LineItem.new({ participant_id: @line_item.participant_id, 
                               order_id: @line_item.order_id, 
                               name: @line_item.name, 
                               price: @line_item.price, 
                               notes: @line_item.notes })
    assert line_item.valid?
    
    # Break the participant relationship, randomly
    line_item.participant_id = rand(9999)
    assert line_item.invalid?
  end
  
  test "line_item attribute order_id must correspond to an existing participant" do
    # Mess with a known good line_item
    line_item = LineItem.new({ participant_id: @line_item.participant_id, 
                               order_id: @line_item.order_id, 
                               name: @line_item.name, 
                               price: @line_item.price, 
                               notes: @line_item.notes })
    assert line_item.valid?
    
    # Break the order relationship, randomly
    line_item.order_id = rand(9999)
    assert line_item.invalid?
  end
  
  test "line_item price must be non-negative" do
    # Mess with a known good line_item
    line_item = LineItem.new({ participant_id: @line_item.participant_id, 
                               order_id: @line_item.order_id, 
                               name: @line_item.name, 
                               price: @line_item.price, 
                               notes: @line_item.notes })
    assert line_item.valid?

    line_item.price = nil
    assert line_item.invalid?
    assert line_item.errors[:price].any?, "blank total should not be allowed"
    
    line_item.price = -1
    assert line_item.invalid?
    assert line_item.errors[:price].any?, "total >= 0 should be enforced"
    
    line_item.price = 0
    assert line_item.valid?
    assert line_item.errors[:price].none?, "total of 0 should be allowed"
    
    line_item.price = 1
    assert line_item.valid?
    assert line_item.errors[:price].none?, "total > 0 should be allowed"
  end
end
