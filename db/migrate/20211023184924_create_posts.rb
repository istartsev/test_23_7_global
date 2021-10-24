class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :body
      t.references :user
      t.integer :likes_count, :null => false, :default => 0
      t.string :status, :null => false, :default => "public"

      t.timestamps
    end
  end
end
