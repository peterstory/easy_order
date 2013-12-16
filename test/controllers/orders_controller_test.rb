require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:valid)
    @invalid_order = orders(:invalid)
    @grill_order = orders(:grill_order)
    login users(:valid).id
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
  
  test "line items should be displayed within order" do 
    get :show, id: @grill_order.id
    assert_response :success, "An order containing line items should load successfully"
    assert_select "li.line_item", @grill_order.line_items.count, "Expected all line items for the order to be displayed"
  end
  
  test "non-admin users should only see orders in which they are participating" do
    User.all.each do |user|
      login user.id      
      get :index
      
      if is_admin?
        # The "+ 1" is for the header row
        assert_select "table tr", Order.count + 1, "Admins should see all orders"
      else
        # The "+ 1" is for the header row
        assert_select "table tr", user.orders.count + 1, "Non-admins should only see the orders in they participate in"
      end
    end
  end
  
  test "mobile devices should get HTML5 inputs" do
    iPhoneAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B329 Safari/8536.25"
    androidAgent = "Mozilla/5.0 (Linux; Android 4.1.1; Nexus 7 Build/JRO03D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Safari/535.19"
    agents = [iPhoneAgent, androidAgent]
    agents.each do |agent|
      @request.user_agent = agent
      get :new
      assert_response :success
    
      assert_select "select#order_placed_at_1i", 0, "Desktop date picker shouldn't be displayed"
      assert_select "input[type='date']", 1, "Mobile date picker should be displayed"
      assert_select "input[type='time']", 1, "Mobile time picker should be displayed"
    end
  end
end
