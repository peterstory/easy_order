require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:valid)
    login @user.id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: @user.email, name: @user.name + "Jr. ", 
                            password: "example password", 
                            password_confirmation: "example password", 
                            role: @user.role }
    end

    assert_redirected_to users_path
  end

  test "should fail to create user" do
    # Passwords should be required to match
    assert_no_difference('User.count') do
      post :create, user: { email: @user.email, name: @user.name, 
                            password: 'valid', 
                            password_confirmation: 'invalid', 
                            role: @user.role }
    end
    # We shouldn't be redirected
    assert_template :new, "user should be prompted for further edits"
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { email: @user.email, name: @user.name, password: @user.password, role: @user.role }
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    # We should be logged out
    assert_equal session[:user_id], nil
    assert_redirected_to root_path
  end
  
  test "role options should be populated" do
    get :new
    assert_select "select#user_role option", (User.valid_roles.count + 1), "Expected number of valid roles, plus a blank option"
    get :edit, id: @user
    assert_select "select#user_role option", (User.valid_roles.count + 1), "Expected number of valid roles, plus a blank option"
  end
  
  test "friend options should be populated" do
    get :new
    assert_select "select#user_friends option", User.count, "Expected number of users"
    get :edit, id: @user
    assert_select "select#user_friends option", (User.count - 1), "Expected number of users, minus ourselves"
  end
  
  test "friend options should be properly preselected" do
    User.all.each do |user|
      get :edit, id: user
      friends = user.friends
      assert_select "select#user_friends option[selected=selected]", friends.count, "Expected correct number of existing friends to be preselected"
      friends.each do |friend|
        assert_select "select#user_friends option[selected=selected][value=" + friend.id.to_s +  "]", 1, "Expected friend to be preselected"
      end
    end
  end
  
  # Additional tests, verifying role-based access controls
  test "new user can create an account" do
    logout
    
    # Get account creation form
    get :new
    assert_response :success, "new user cannot load account creation form"
    
    # Create account
    assert_difference('User.count') do
      post :create, user: { email: @user.email, name: @user.name + "Jr. ", 
                            password: "example password", 
                            password_confirmation: "example password", 
                            role: @user.role }
    end
    assert_redirected_to users_path, "new user not properly redirected"
  end
  
  test "standard user disallowed features" do
    # Log in standard user
    user = users(:bill)
    login user.id
    
    # Attempt creation of additional account
    get :new
    assert_redirected_to users_path
    assert flash[:notice] == "Operation not permitted by non-admin"
    post :create
    assert_redirected_to users_path
    assert flash[:notice] == "Operation not permitted by non-admin"
    
    # Attempt edit of another user
    get :edit, id: @user.id
    assert_redirected_to users_path
    assert flash[:notice] == "Operation not permitted by other users"
    patch :update, id: @user.id
    assert_redirected_to users_path
    assert flash[:notice] == "Operation not permitted by other users"
    
    # Attempt deletion of another user
    delete :destroy, id: @user
    assert_redirected_to users_path
    assert flash[:notice] == "Operation not permitted by other users"
  end
  
end
