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
      # I don't think this is the safest way!
      
      # Update order's total
      order = self.order
      order_total = 0
      order.line_items.each do |line_item|
        order_total += line_item.price
      end
      order.total = order_total
      order.save
      
      # Update participant's total
      participant = self.participant
      participant_total = 0
      participant.line_items.each do |line_item|
        participant_total += line_item.price
      end
      participant.total = participant_total
      participant.save
    end
end
