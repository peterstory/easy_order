require 'test_helper'

class RestaurantsControllerTest < ActionController::TestCase
  setup do
    @restaurant = restaurants(:valid)
    @invalid_restaurant = restaurants(:invalid)
    @restaurant_with_menu = restaurants(:the_grill)
    @menu = menus(:valid)
    login users(:valid).id
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
                                  fax: @restaurant.fax,
                                  name: @restaurant.name, phone: @restaurant.phone, 
                                  state: @restaurant.state, street1: @restaurant.street1, 
                                  street2: @restaurant.street2, url: @restaurant.url, 
                                  zipcode: @restaurant.zipcode }
    end

    assert_redirected_to restaurant_path(assigns(:restaurant))
  end
  
  test "should not create invalid restaurant" do
    assert_no_difference('Restaurant.count') do
      post :create, restaurant: { city: @invalid_restaurant.city, cuisine: @invalid_restaurant.cuisine,
                                  delivers: @invalid_restaurant.delivers, 
                                  delivery_charge: @invalid_restaurant.delivery_charge, 
                                  description: @invalid_restaurant.description, 
                                  fax: @invalid_restaurant.fax, 
                                  name: @invalid_restaurant.name, phone: @invalid_restaurant.phone, 
                                  state: @invalid_restaurant.state, street1: @invalid_restaurant.street1, 
                                  street2: @invalid_restaurant.street2, url: @invalid_restaurant.url, 
                                  zipcode: @invalid_restaurant.zipcode }
    end

    assert_template :new, "user should be prompted for further edits"
  end
  
  test "should create restaurant with menu" do
    originalNumberOfMenus = Menu.count
    
    assert_difference('Restaurant.count') do
      post :create, restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine,
                                  delivers: @restaurant.delivers, 
                                  delivery_charge: @restaurant.delivery_charge, 
                                  description: @restaurant.description, 
                                  fax: @restaurant.fax,
                                  name: @restaurant.name, phone: @restaurant.phone, 
                                  state: @restaurant.state, street1: @restaurant.street1, 
                                  street2: @restaurant.street2, url: @restaurant.url, 
                                  zipcode: @restaurant.zipcode,
                                  uploaded_menu: fixture_file_upload('../fixtures/binaries/ImageMenu.png', 'image/png')}
    end
    
    assert (Menu.count != originalNumberOfMenus), "a menu should be added to the database"

    assert_redirected_to restaurant_path(assigns(:restaurant))
  end
  
  test "should not create a restaurant with an invalid menu" do
    originalNumberOfMenus = Menu.count
    
    assert_no_difference('Restaurant.count') do
      post :create, restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine,
                                  delivers: @restaurant.delivers, 
                                  delivery_charge: @restaurant.delivery_charge, 
                                  description: @restaurant.description, 
                                  fax: @restaurant.fax,
                                  name: @restaurant.name, phone: @restaurant.phone, 
                                  state: @restaurant.state, street1: @restaurant.street1, 
                                  street2: @restaurant.street2, url: @restaurant.url, 
                                  zipcode: @restaurant.zipcode,
                                  uploaded_menu: fixture_file_upload('../fixtures/binaries/InvalidMenu.rtf', 'application/rtf')}
    end
    
    assert (Menu.count == originalNumberOfMenus), "an invalid menu should not be added to the database"
    
    assert_template :new, "user should be prompted for further edits"
  end
  
  test "uploading a new menu should remove the old menu" do
    originalNumberOfMenus = Menu.count
    originalMenuID = @restaurant_with_menu.menu.id
    
    patch :update, id: @restaurant_with_menu, restaurant: { uploaded_menu: fixture_file_upload('../fixtures/binaries/PDFMenu.pdf', 'application/pdf')}
        
    assert (Menu.count == originalNumberOfMenus), "old menu should be deleted if a new menu is added"
    # We must query the database, since @restaurant_with_menu is stale
    assert (Restaurant.find(@restaurant_with_menu.id).menu.id != originalMenuID), "new menu should replace old menu"

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
    patch :update, id: @restaurant, restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, delivers: @restaurant.delivers, delivery_charge: @restaurant.delivery_charge, description: @restaurant.description, fax: @restaurant.fax, name: @restaurant.name, phone: @restaurant.phone, state: @restaurant.state, street1: @restaurant.street1, street2: @restaurant.street2, url: @restaurant.url, zipcode: @restaurant.zipcode }
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end
  
  test "should not update invalid restaurant" do
    patch :update, id: @restaurant, restaurant: { city: @invalid_restaurant.city, cuisine: @invalid_restaurant.cuisine,
                                                  delivers: @invalid_restaurant.delivers, 
                                                  delivery_charge: @invalid_restaurant.delivery_charge, 
                                                  description: @invalid_restaurant.description, 
                                                  fax: @invalid_restaurant.fax, 
                                                  name: @invalid_restaurant.name, phone: @invalid_restaurant.phone, 
                                                  state: @invalid_restaurant.state, street1: @invalid_restaurant.street1, 
                                                  street2: @invalid_restaurant.street2, url: @invalid_restaurant.url, 
                                                  zipcode: @invalid_restaurant.zipcode }
    assert_template :edit, "user should be prompted for further edits"
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete :destroy, id: @restaurant
    end

    assert_redirected_to restaurants_path
  end
  
  test "cuisine options should be populated" do
    get :new
    assert_select "select#restaurant_cuisine option", (Restaurant.valid_cuisines.count + 1), "Expected number of valid cuisines, plus a blank option"
    get :edit, id: @restaurant
    assert_select "select#restaurant_cuisine option", (Restaurant.valid_cuisines.count + 1), "Expected number of valid cuisines, plus a blank option"
  end
  
  test "restaurant map should be loaded" do
    get :show, id: @restaurant
    assert_select ".map img", 1, "Map should be loaded"
  end
end
