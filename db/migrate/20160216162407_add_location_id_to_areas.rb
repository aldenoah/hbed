class AddLocationIdToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :location_id, :integer
    add_index :areas, :location_id
  end
end
