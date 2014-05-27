class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :accepted_answer_id
      t.integer :score
      t.integer :view_count
      t.integer :answer_count
    end
  end
end
