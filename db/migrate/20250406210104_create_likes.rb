class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :likeable_id, null: false
      t.string :likeable_type, null: false
      t.timestamps
    end

    add_index :likes, [ :likeable_type, :likeable_id ]
  end
end
