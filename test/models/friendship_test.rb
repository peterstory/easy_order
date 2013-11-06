require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  setup do
    @friendship = friendships(:valid)
    @invalid_friendship = friendships(:invalid)
  end
  
  test "known good friendship should validate" do
    assert @friendship.valid?
  end
  
  test "known bad friendship should not validate" do
    assert @invalid_friendship.invalid?
  end
  
  test "friendship attributes must not be empty" do
    friendship = Friendship.new
    assert friendship.invalid?
    #assert friendship.errors[:user_id].any?, "user_id should be required"
    assert friendship.errors[:friend_id].any?, "friend_id should be required"
  end
  
  test "friendship attribute friend_id must correspond to an existing user" do
    # Mess with a known good friendship
    friendship = Friendship.new({user_id: @friendship.user_id, friend_id: @friendship.friend_id})
    assert friendship.valid?
    
    # Break the friendship, randomly
    friendship.friend_id = rand(9999)
    assert friendship.invalid?
  end
  
end
