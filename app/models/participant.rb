class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :participating_user, class_name: 'User', foreign_key: 'user_id'  # Same as above, clearly named
  belongs_to :order
end
