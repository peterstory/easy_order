require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  setup do
    @menu = menus(:valid)
    @invalid_menu = menus(:invalid)
  end
  
  test "known good menu should validate" do
    assert @menu.valid?
  end
  
  test "known bad menu should not validate" do
    assert @invalid_menu.invalid?
  end
  
  test "menu attributes must not be empty" do
    menu = Menu.new
    assert menu.invalid?
    assert menu.errors[:name].any?, "name should be required"
    assert menu.errors[:content_type].any?, "content_type should be required"
    assert menu.errors[:data].any?, "data should be required"
    # Note that restaurant is not checked, since it isn't required. This is an 
    # artifact of the Menu being created before the Restaurant when a new 
    # Restaurant is created. 
  end
  
  # Only image content types and the PDF content type should be allowed
  test "content_type attribute's validity must be enforced" do
    # Mess up a known good menu
    menu = Menu.new ({ name: @menu.name, content_type: @menu.content_type, 
                       data: @menu.data, restaurant_id: @menu.restaurant_id })
    assert menu.valid?
    
    # Rich text content types shouldn't be allowed
    menu.content_type = "application/rtf"
    assert menu.invalid?
    assert menu.errors[:file_type].any?, "non-image or PDF content types should be disallowed"
    
    # PDF content type should be allowed
    menu.content_type = "application/pdf"
    assert menu.valid?
    assert menu.errors[:file_type].none?, "PDF content type should be allowed"
    
    # Any image content type should be allowed
    menu.content_type = "image/anything-goes-here"
    assert menu.valid?
    assert menu.errors[:file_type].none?, "image content types should be allowed"
  end
end
