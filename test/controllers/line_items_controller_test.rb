require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:valid)
    @order = @line_item.order
  end

  # Line items are only viewable in the context of their order, so 
  # we don't need to test for index
    
  test "should get new" do
    get :new, order_id: @order.id
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, order_id: @order.id, line_item: { name: @line_item.name, 
                                                      notes: @line_item.notes, 
                                                      order_id: @line_item.order_id, 
                                                      participant_id: @line_item.participant_id, 
                                                      price: @line_item.price }
    end

    assert_redirected_to @order
  end

  test "should show line_item" do
    get :show, order_id: @order.id, id: @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, order_id: @order.id, id: @line_item
    assert_response :success
  end

  test "should update line_item" do
    patch :update, order_id: @order.id, id: @line_item, line_item: { name: @line_item.name, notes: @line_item.notes, order_id: @line_item.order_id, participant_id: @line_item.participant_id, price: @line_item.price }
    assert_redirected_to order_line_item_path(order_id: @order.id, id: assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, order_id: @order.id, id: @line_item
    end

    assert_redirected_to @order
  end
end
