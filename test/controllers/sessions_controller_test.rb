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
    
    assert_redirected_to login_url
  end

  test "should log out" do
    # First "log in"
    session[:user_id] = users(:valid).id
    
    # Now log out
    get :destroy
    assert_redirected_to root_path
    assert_equal nil, session[:user_id]
  end

end
