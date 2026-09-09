class DocumentChunk < ApplicationRecord
  belongs_to :document

  has_neighbors :embedding

  validates :content, presence: true
  validates :chunk_index, presence: true
end
