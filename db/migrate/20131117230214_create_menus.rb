class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :content_type
      t.binary :data, limit: 50.megabyte
      t.references :restaurant, index: true

      t.timestamps
    end
    
    remove_column :restaurants, :menu_file, :string
  end
end
