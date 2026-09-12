# This service is used for chat with Ai Model
require_relative "error"
class Ai::Client
  MODELS = [
    "nvidia/nemotron-3-super-120b-a12b:free",
    "minimax/minimax-m3:free",
    "google/gemma-4-31b-it:free"
  ].freeze

  EMBEDDING_MODEL = "liquid/lfm-2.5-embedding-350m:free"

  BASE_URL = "https://openrouter.ai/api/v1"

  def initialize
    @api_key = Rails.application.credentials.dig(:openrouter, :api_key)

    raise "OpenRouter API key is missing" if @api_key.blank?

    @client = OpenAI::Client.new(
      api_key: @api_key,
      base_url: BASE_URL
    )
  end

  def chat(messages:)
    response = @client.chat.completions.create(
      model: MODELS.first,
      messages: messages,
      request_options: {
        extra_body: {
          models: MODELS.drop(1)
        }
      }
    )

    {
      content: response.choices.first.message.content,
      model: response.model,
      input_tokens: response.usage.prompt_tokens,
      output_tokens: response.usage.completion_tokens
    }
  rescue OpenAI::Errors::RateLimitError => e
    raise Ai::RateLimitError, e.message

  rescue OpenAI::Errors::APITimeoutError => e
    raise Ai::TimeoutError, e.message

  rescue OpenAI::Errors::APIConnectionError => e
    raise Ai::ProviderError, e.message

  rescue OpenAI::Errors::BadRequestError,
          OpenAI::Errors::AuthenticationError,
          OpenAI::Errors::PermissionDeniedError,
          OpenAI::Errors::NotFoundError,
          OpenAI::Errors::ConflictError,
          OpenAI::Errors::UnprocessableEntityError,
          OpenAI::Errors::InternalServerError,
          OpenAI::Errors::APIStatusError => e
    raise Ai::ProviderError, e.message
  end

  def stream_chat(messages:, &on_delta)
    stream = @client.chat.completions.stream_raw(
      model: MODEL,
      messages: messages
    )

    final_usage = nil

    stream.each do |chunk|
      if chunk.choices.any?
        delta = chunk.choices.first&.delta&.content

        on_delta.call(delta) if delta.present?
      end

      final_usage = chunk.usage if chunk.usage
    end

    {
      model: MODEL,
      input_tokens: final_usage&.prompt_tokens,
      output_tokens: final_usage&.completion_tokens
    }
  end

  def embed(text:)
    response = @client.embeddings.create(
      model: EMBEDDING_MODEL,
      input: text
    )

    {
      embedding: response.data.first.embedding,
      model: response.model,
      input_tokens: response.usage&.prompt_tokens
    }
  end
end
