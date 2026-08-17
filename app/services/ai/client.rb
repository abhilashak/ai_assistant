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

  def chat(message:)
    @client.chat.completions.create(
      model: MODEL,
      messages: [
        {
          role: "user",
          content: message
        }
      ]
    )
  end
end
