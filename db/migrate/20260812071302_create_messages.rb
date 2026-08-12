class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.string :role
      t.text :content
      t.string :model
      t.integer :input_tokens
      t.integer :output_tokens

      t.timestamps
    end
  end
end
