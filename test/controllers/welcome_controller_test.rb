require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should link to signup page" do
    get :index
    assert_select "a[href='/users/new']", 1, "Expected a link to the signup page"
  end

end
