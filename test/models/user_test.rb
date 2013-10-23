require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user attributes must not be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?, "name should be required"
    assert user.errors[:email].any?, "email should be required "
    assert user.errors[:password].any?, "password should be required"
    assert user.errors[:role].any?, "role should be required"
  end
end
