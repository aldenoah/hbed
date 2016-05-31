class AddPremiseToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :premise_name, :string
    add_column :rooms, :book_start, :integer
    add_column :rooms, :book_end, :integer
  end
end
