class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.integer :room_id

      t.timestamps null: false
    end
    add_index :uploads, :room_id
  end
end
