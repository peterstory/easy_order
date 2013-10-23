require 'test_helper'

class RestaurantsControllerTest < ActionController::TestCase
  setup do
    @restaurant = restaurants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restaurants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post :create, restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine,
                                  delivers: @restaurant.delivers, 
                                  delivery_charge: @restaurant.delivery_charge, 
                                  description: @restaurant.description, 
                                  fax: @restaurant.fax, menu_file: @restaurant.menu_file, 
                                  name: @restaurant.name, phone: @restaurant.phone, 
                                  state: @restaurant.state, street1: @restaurant.street1, 
                                  street2: @restaurant.street2, url: @restaurant.url, 
                                  zipcode: @restaurant.zipcode }
    end

    assert_redirected_to restaurant_path(assigns(:restaurant))
  end

  test "should show restaurant" do
    get :show, id: @restaurant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @restaurant
    assert_response :success
  end

  test "should update restaurant" do
    patch :update, id: @restaurant, restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, delivers: @restaurant.delivers, delivery_charge: @restaurant.delivery_charge, description: @restaurant.description, fax: @restaurant.fax, menu_file: @restaurant.menu_file, name: @restaurant.name, phone: @restaurant.phone, state: @restaurant.state, street1: @restaurant.street1, street2: @restaurant.street2, url: @restaurant.url, zipcode: @restaurant.zipcode }
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete :destroy, id: @restaurant
    end

    assert_redirected_to restaurants_path
  end
end
