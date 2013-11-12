class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :user, index: true
      t.references :order, index: true
      t.string :role, null: false
      t.float :total

      t.timestamps
    end
  end
end
