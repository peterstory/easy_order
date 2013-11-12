class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :restaurant, index: true, null: false
      t.integer :organizer_id, null: false
      t.string :type, null: false
      t.float :total
      t.string :status, null: false
      t.datetime :placed_at, null: false

      t.timestamps
    end
  end
end
