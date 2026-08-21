# This service is used for chatting with AI model
# uses the prompt builder class to build the messages of the particular
# conversations and store the conversation and the messages
class Ai::ChatService
  def initialize(ai_client: Ai::Client.new, prompt_builder_class: Ai::PromptBuilder)
    @ai_client = ai_client
    @prompt_builder_class = prompt_builder_class
  end

  def call(conversation:, user_message:)
    conversation.transaction do
      # save user message
      conversation.messages.create!(
        role: :user,
        content: user_message
      )

      # load conversation history, build LLM message
      messages = @prompt_builder_class.new(
        conversation: conversation
      ).build

      # call LLM
      result = @ai_client.chat(messages: messages)

      # save assistant response
      conversation.messages.create!(
        role: :assistant,
        content: result[:content],
        model: result[:model],
        input_tokens: result[:input_tokens],
        output_tokens: result[:output_tokens]
      )
    end
  end
end
