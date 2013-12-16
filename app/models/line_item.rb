class LineItem < ActiveRecord::Base
  after_commit :recalculate_totals
  
  belongs_to :participant
  validates :participant_id, presence: true
  validates :participant, presence: true
  
  belongs_to :order
  validates :order_id, presence: true
  validates :order, presence: true
  
  validates :name, presence: true
  
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  
  private
    # Recalculate the participant's and order's totals
    def recalculate_totals
      # Update order's total
      if self.order
        self.order.update_total
      end
      
      # Update participant's total
      if self.participant
        self.participant.update_total
      end
    end
end
