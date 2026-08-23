# This service is used for chat with Ai Model
class Ai::Client
  MODEL = "openrouter/free"
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
      model: MODEL,
      messages: messages
    )

    {
      content: response.choices.first.message.content,
      model: response.model,
      input_tokens: response.usage.prompt_tokens,
      output_tokens: response.usage.completion_tokens
    }
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
end
