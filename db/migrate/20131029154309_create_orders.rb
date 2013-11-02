class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :restaurant_id
      t.integer :organizer_id
      t.string :type
      t.float :total
      t.string :status
      t.datetime :placed_at

      t.timestamps
    end
  end
end
