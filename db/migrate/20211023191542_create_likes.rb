class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes, id: false, primary_key: %i[user post] do |t|
      t.references :user
      t.references :post
    end
  end
end
