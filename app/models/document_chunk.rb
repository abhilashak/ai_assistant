class DocumentChunk < ApplicationRecord
  belongs_to :document

  has_neighbors :embedding

  validates :content, presence: true
  validates :chunk_index, presence: true

  scope :has_embedding, -> { where.not(embedding: nil) }
end
