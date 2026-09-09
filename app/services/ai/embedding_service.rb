class Ai::EmbeddingService
  def initialize(ai_client: Ai::Client.new)
    @ai_client = ai_client
  end

  def call(text:)
    result = @ai_client.embed(text: text)

    result[:embedding]
  end
end
