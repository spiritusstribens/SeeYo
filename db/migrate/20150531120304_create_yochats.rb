class CreateYochats < ActiveRecord::Migration
  def change
    create_table :yochats do |t|
      t.integer :user_id
      t.string :share_with
      t.text :content

      t.timestamps null: false
    end
  end
end
