require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should log in" do
    user = users(:valid)
    post :create, name: user.name, password: 'SuperGoodPassword'
    
    assert_redirected_to root_path
    assert_equal user.id, session[:user_id]
  end
  
  test "should fail login" do
    user = users(:valid)
    post :create, name: user.name, password: 'invalid'
    
    assert_template 'new', "should stay on login page"
    assert flash[:notice], "a message should be displayed"
  end

  test "should log out" do
    # First "log in"
    login users(:valid).id
    
    # Now log out
    get :destroy
    assert_redirected_to root_path
    assert_equal nil, session[:user_id]
  end

end
