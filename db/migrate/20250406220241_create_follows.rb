class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows, primary_key: [:following_user_id, :followed_user_id] do |t|
      t.integer :following_user_id, null: false
      t.integer :followed_user_id, null: false

      t.timestamps
    end

    add_index :follows, [:following_user_id, :followed_user_id], unique: true
  end
end
