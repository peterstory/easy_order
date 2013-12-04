require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "links should appear properly before login" do
    get :index
    
    # There should be a signup link in the navigation bar, and in the call to action
    assert_select "a[href='/users/new']", 2, "Expected two links to the signup page"
    
    # Should be a single login link
    assert_select "a[href='/login']", 1, "Expected a link to the login page"
    
    # In navigation bar, there should only be "Sign In" and "Sign Up"
    assert_select "nav div#links>ul>li", 2, "Expected two links in the nav bar"
  end
  
  test "links should appear properly after login" do
    login users(:valid).id
    get :index
    
    assert_select "a[href='/login']", 0, "Expected no link to the login page"
    
    assert_select "a[href='/users/new']", 0, "Expected no links to the signup page"
    
    assert_select "a[data-method='delete'][href='/logout']", 1, "Expected link to the signout page"
    
    # In navigation bar, there should be "Users", "Restaurants", "Orders", "Account", and "Sign Out"
    assert_select "nav div#links>ul>li", 5, "Expected five links in the nav bar"
  end
  
end
