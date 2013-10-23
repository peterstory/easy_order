require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test "friendship attributes must not be empty" do
    friendship = Friendship.new
    assert friendship.invalid?
    assert friendship.errors[:user_id].any?, "user_id should be required"
    assert friendship.errors[:friend_id].any?, "friend_id should be required"
  end
end
