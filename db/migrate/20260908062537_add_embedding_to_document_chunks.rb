class AddEmbeddingToDocumentChunks < ActiveRecord::Migration[8.1]
  def change
    add_column :document_chunks, :embedding, :vector, limit: 1024
  end
end
