class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.text :description
      t.string :cuisine, null: false
      t.string :street1, null: false
      t.string :street2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zipcode, null: false
      t.string :phone, null: false
      t.string :fax
      t.string :url, null: false
      t.boolean :delivers
      t.float :delivery_charge
      t.string :menu_file

      t.timestamps
    end
  end
end
