require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:valid)
    @invalid_order = orders(:invalid)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { organizer_id: @order.organizer_id, placed_at: @order.placed_at, restaurant_id: @order.restaurant_id, status: @order.status, total: @order.total, type: @order.type }
    end

    assert_redirected_to order_path(assigns(:order))
  end
  
  test "should fail to create order" do
    assert_no_difference('Order.count') do
      post :create, order: { organizer_id: @invalid_order.organizer_id, 
                             placed_at: @invalid_order.placed_at, 
                             restaurant_id: @invalid_order.restaurant_id, 
                             status: @invalid_order.status, total: @invalid_order.total, 
                             type: @invalid_order.type }
    end

    # We shouldn't be redirected
    assert_template :new, "user should be prompted for further edits"
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { organizer_id: @order.organizer_id, placed_at: @order.placed_at, restaurant_id: @order.restaurant_id, status: @order.status, total: @order.total, type: @order.type }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
  
  test "restaurant options should be populated" do
    get :new
    assert_select "select#order_restaurant_id option", Restaurant.count + 1, "Expected number of restaurants, plus a blank option"
    get :edit, id: @order
    assert_select "select#order_restaurant_id option", Restaurant.count + 1, "Expected number of restaurants, plus a blank option"
  end
  
  test "organizer options should be populated" do
    get :new
    assert_select "select#order_organizer_id option", User.count + 1, "Expected number of users, plus a blank option"
    get :edit, id: @order
    assert_select "select#order_organizer_id option", User.count + 1, "Expected number of users, plus a blank option"
  end
  
  test "participant options should be populated" do
    get :new
    assert_select "select#order_participating_users option", User.count, "Expected number of users"
    get :edit, id: @order
    assert_select "select#order_participating_users option", User.count, "Expected number of users"
  end
  
  test "participant options should be properly preselected" do
    Order.all.each do |order|
      get :edit, id: order
      participating_users = order.participating_users
      assert_select "select#order_participating_users option[selected=selected]", participating_users.count, "Expected correct number of existing participating users to be preselected"
      participating_users.each do |user|
        assert_select "select#order_participating_users option[selected=selected][value=" + user.id.to_s +  "]", 1, "Expected participating user '#{user.name}' to be preselected"
      end
    end
  end
  
  test "type options should be populated" do
    get :new
    assert_select "input[name='order[type]']", Order.valid_types.count, "Expected number of valid roles"
    get :edit, id: @order
    assert_select "input[name='order[type]']", Order.valid_types.count, "Expected number of valid roles"
  end
  
  test "status options should be populated" do
    get :new
    assert_select "input[name='order[status]']", Order.valid_statuses.count, "Expected number of valid statuses"
    get :edit, id: @order
    assert_select "input[name='order[status]']", Order.valid_statuses.count, "Expected number of valid statuses"
  end
  
  
  
end
