class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :currency, :string
    add_column :users, :role, :string, default: "Member"
    add_index :users, :role
  end
end
