class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :organization, :string
    add_column :users, :contact_name, :string
    add_column :users, :username, :string
    add_column :users, :approved, :boolean
    add_column :users, :role, :string
  end
end
