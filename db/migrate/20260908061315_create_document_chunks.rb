class CreateDocumentChunks < ActiveRecord::Migration[8.1]
  def change
    create_table :document_chunks do |t|
      t.references :document, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :chunk_index, null: false

      t.timestamps
    end

    add_index(
      :document_chunks,
      [ :document_id, :chunk_index ], unique: true
    )
  end
end
