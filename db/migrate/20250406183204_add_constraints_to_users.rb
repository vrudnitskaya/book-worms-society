class AddConstraintsToUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
