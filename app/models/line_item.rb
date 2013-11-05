class LineItem < ActiveRecord::Base
  belongs_to :participant
  belongs_to :order
end
