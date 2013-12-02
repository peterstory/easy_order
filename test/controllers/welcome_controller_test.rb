require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  # There should be a link in the navigation bar, and in the call to action
  test "should link to signup page" do
    get :index
    assert_select "a[href='/users/new']", 2, "Expected two links to the signup page"
  end

end
