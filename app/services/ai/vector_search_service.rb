# @params: query(String)
# @return DocumentChunk
class Ai::VectorSearchService
  DEFAULT_LIMIT = 1

  def initialize(embedding_service: Ai::EmbeddingService.new)
    @embedding_service = embedding_service
  end

  def call(query:, limit: DEFAULT_LIMIT)
    embedding = @embedding_service.call(text: query)

    DocumentChunk.has_embedding
                 .nearest_neighbors(:embedding, embedding, distance: "cosine")
                 .limit(limit)
  end
end
