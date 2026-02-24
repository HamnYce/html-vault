class CreateSnippets < ActiveRecord::Migration[8.1]
  def change
    create_table :snippets do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :html_content, null: false
      t.string :tags, null: false

      # creates created_at and updated_at and manages them
      t.timestamps
    end
    add_index :snippets, :slug, unique: true
  end
end
