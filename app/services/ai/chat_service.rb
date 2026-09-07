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
      user_message_record = conversation.messages.create!(
        role: :user,
        content: user_message
      )

      # load conversation history, build LLM message
      messages = @prompt_builder_class.new(
        conversation: conversation
      ).build

      # store metadata
      ai_request = conversation.ai_requests.create!(
        message: user_message_record,
        provider: "openrouter",
        model: Ai::Client::MODEL,
        operation: "chat",
        status: :pending,
        streamed: false,
        started_at: Time.current,
        request_id: SecureRandom.uuid
      )

      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      begin
        # call LLM
        result = @ai_client.chat(messages: messages)

        latency_ms =
          (
            Process.clock_gettime(Process::CLOCK_MONOTONIC) -
            started_at
          ) * 1000

        # save assistant response
        assistant_message = conversation.messages.create!(
          role: :assistant,
          content: result[:content],
          model: result[:model],
          input_tokens: result[:input_tokens],
          output_tokens: result[:output_tokens]
        )

        ai_request.update!(
          message: assistant_message,
          status: :success,
          input_tokens: result[:input_tokens],
          output_tokens: result[:output_tokens],
          latency_ms: latency_ms.round,
          completed_at: Time.current,
          http_status: 200
        )

        assistant_message
      rescue => e
        ai_request.update!(
          status: :failed,
          error_class: e.class.name,
          error_message: e.message,
          completed_at: Time.current
        )

        raise
      end
    end
  end
end
