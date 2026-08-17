# This service is used for chatting with Ai model and store
# the conversation into the Message model
class Ai::ChatService
  def initialize(ai_client: Ai::Client.new)
    @ai_client = ai_client
  end

  def call(conversation:, user_message:)
    result = @ai_client.chat(message: user_message)

    # TODO check result is success or not here
    user_message_record = conversation.messages.create!(
      role: :user,
      content: user_message
    )
    assistant_message_record = conversation.messages.create!(
      role: :assistant,
      content: result[:content],
      model: result[:model],
      input_tokens: result[:input_tokens],
      output_tokens: result[:output_tokens]
    )

    {
      user_message: user_message_record,
      assistant_message: assistant_message_record
    }
  end
end
