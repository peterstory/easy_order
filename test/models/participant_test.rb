require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  setup do
    @participant = participants(:valid)
    @invalid_participant = participants(:invalid)
  end
  
  test "known good participant should validate" do
    assert @participant.valid?
  end
  
  test "known bad participant should not validate" do
    assert @invalid_participant.invalid?
  end
  
  test "participant attributes must not be empty" do
    participant = Participant.new
    assert participant.invalid?
    assert participant.errors[:user].any?, "valid user should be required"
    assert participant.errors[:role].any?, "role should be required"
    assert participant.errors[:total].none?, "total can be blank"
  end
  
  #test "participant attribute user_id must correspond to an existing user" do
  #  # Mess with a known good participant
  #  participant = Participant.new({user_id: @friendship.user_id, friend_id: @friendship.friend_id})
  #  assert friendship.valid?
  #  
  #  # Break the friendship, randomly
  #  friendship.friend_id = rand(9999)
  #  assert friendship.invalid?
  #end
    
end
