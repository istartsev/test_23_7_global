class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.boolean :active, null: false, default: true
      t.string :password
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
