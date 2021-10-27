class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :post
      t.references :user
    end
    add_index(:likes, [:post_id, :user_id], unique: true)
  end
end
