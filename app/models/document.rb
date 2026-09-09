class Document < ApplicationRecord
  has_many :document_chunks, dependent: :destroy

  validates :title, presence: true
end
