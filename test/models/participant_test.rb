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
    participant.role = nil  # It is set by default, so we explicitly mess it up
    assert participant.invalid?
    assert participant.errors[:user].any?, "valid user should be required"
    assert participant.errors[:role].any?, "role should be required"
    assert participant.errors[:total].none?, "total can be blank"
  end
  
  test "participant attribute user_id must correspond to an existing user" do
    # Mess with a known good participant
    participant = Participant.new({ user_id: @participant.user_id, 
                                    order_id: @participant.order_id, 
                                    role: @participant.role, 
                                    total: @participant.total })
    assert participant.valid?
    
    # Break the user relationship, randomly
    participant.user_id = rand(9999)
    assert participant.invalid?
  end
    
  test "participant total must be non-negative" do
    # Mess with a known good participant
    participant = Participant.new({ user_id: @participant.user_id, 
                                    order_id: @participant.order_id, 
                                    role: @participant.role, 
                                    total: @participant.total })
    assert participant.valid?
    
    participant.total = -1
    assert participant.invalid?
    assert participant.errors[:total].any?, "total >= 0 should be enforced"
    
    participant.total = 0
    assert participant.valid?
    assert participant.errors[:total].none?, "total of 0 should be allowed"
    
    participant.total = 1
    assert participant.valid?
    assert participant.errors[:total].none?, "total > 0 should be allowed"
    
    participant.total = nil
    assert participant.valid?
    assert participant.errors[:total].none?, "blank total should be allowed"
  end
  
  test "participant role attribute must be valid" do
    # Mess with the known good participant
    participant = Participant.new({ user_id: @participant.user_id, 
                                    order_id: @participant.order_id, 
                                    role: @participant.role, 
                                    total: @participant.total })
    assert participant.valid?
    
    # Make sure there are valid role types to choose from
    assert Participant.valid_roles, "no valid roles available"
    assert Participant.valid_roles.length > 0, "no valid roles available"
    
    # Make sure the valid roles are accepted
    Participant.valid_roles.each do |role|
      participant.role = role
      assert participant.valid?, "valid role '#{participant.role}' should be accepted"
    end
  end
end
