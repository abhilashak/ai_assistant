class Ai::RagService
  DEFAULT_LIMIT = 5

  def initialize(ai_client: Ai::Client.new, vector_search_service: Ai::VectorSearchService.new)
    @ai_client = ai_client
    @vector_search = vector_search_service
  end

  def call(conversation:, question:, limit: DEFAULT_LIMIT)
    chunks = @vector_search.call(query: question, limit: limit)

    context = build_context(chunks)

    messages = Ai::PromptBuilder.new(conversation: conversation,
                                     context: context,
                                     current_question: question).build

    @ai_client.chat(messages: messages)
  end

  private

  def build_context(chunks)
    chunks.map.with_index(1) do |chunk, index|
      <<~TEXT
        [Source #{index}]
        Document: #{chunk.document.title}
        Chunk: #{chunk.chunk_index}

        #{chunk.content}
      TEXT
    end.join('\n')
  end
end
