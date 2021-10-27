class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :body
      t.string :comment
      t.references :user
      t.integer :likes_count, null:false, default: 0
      t.datetime :deleted_at, index:true

      t.timestamps
    end
  end
end
