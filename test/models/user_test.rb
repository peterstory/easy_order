require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:valid)
    @invalid_user = users(:invalid)
  end
  
  test "a known good user should validate" do
    valid_user = User.new({name: @user.name + " Jr.", password: 'test', password_confirmation: 'test', email: @user.email, role: @user.role})
    assert valid_user.valid?
  end

  test "a known bad user should not validate" do
    assert @invalid_user.invalid?
  end

  test "user attributes must not be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?, "name should be required"
    assert user.errors[:email].any?, "email should be required "
    assert user.errors[:password].any?, "password should be required"
    assert user.errors[:role].any?, "role should be required"
  end
  
  test "user email attribute must be properly formatted" do
    # Mess with the known good user
    user = User.new({name: @user.name + " Jr.", password: 'test', password_confirmation: 'test', email: @user.email, role: @user.role})
    assert user.valid?

    # Now, try an email without a username
    user.email = "@example.com"
    user.invalid?
    assert user.errors[:email].any?, "email format should require a username"
    user.email = "example.com"
    user.invalid?
    assert user.errors[:email].any?, "email format should require a username"
    
    # Now, try an email without a server
    user.email = "john@"
    user.invalid?
    assert user.errors[:email].any?, "email format should require a server"
    user.email = "john"
    user.invalid?
    assert user.errors[:email].any?, "email format should require a server"
    
    # Now, try an email without a TLD
    user.email = "john@localhost"
    user.invalid?
    assert user.errors[:email].any?, "email format requires a top-level domain name"
    
    # Now, try an email with an invalid TLD (too short)
    user.email = "john@localhost.w"
    user.invalid?
    assert user.errors[:email].any?, "email format requires a valid top-level domain name"
  end
  
  test "user role attribute must be valid" do
    # Mess with the known good user
    user = User.new({name: @user.name + " Jr.", password: 'test', password_confirmation: 'test', email: @user.email, role: @user.role})
    assert user.valid?
    
    # Make sure there are valid roles
    assert User.valid_roles, "no valid roles available"
    assert User.valid_roles.length > 0, "no valid roles available"
    
    # Make sure the valid roles are accepted
    User.valid_roles.each do |role|
      user.role = role
      assert user.valid?, "valid role '#{user.role}' should be accepted"
    end
  end
  
  test "user name must be unique" do 
    # Use the known good user, who is already in the database
    user = User.new({name: @user.name, password: 'test', password_confirmation: 'test', email: @user.email, role: @user.role})
    assert user.invalid?, "user name uniqueness should be enforced"
  end
end
