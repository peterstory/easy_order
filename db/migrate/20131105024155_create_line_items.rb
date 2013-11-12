class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :participant, index: true
      t.references :order, index: true
      t.string :name, null: false
      t.float :price, null: false
      t.text :notes

      t.timestamps
    end
  end
end
