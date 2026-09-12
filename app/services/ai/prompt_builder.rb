class Ai::PromptBuilder
  SYSTEM_PROMPT = <<~PROMPT
    You are a helpful AI assistant.

    Answer questions clearly and concisely.

    When document context is provided:
    - Use the provided context as the primary source of truth.
    - Do not invent information that is not supported by the context.
    - If the answer cannot be determined from the context, say that you don't have enough information.
  PROMPT

  def initialize(conversation:, context: nil, current_question:)
    @conversation = conversation
    @context = context
    @current_question = current_question
  end

  def build
    messages = [
      {
        role: "system",
        content: SYSTEM_PROMPT.strip
      }
    ]

    if @context.present?
      messages << {
        role: "system",
        content: <<~CONTEXT
          Use the following document context to answer the user's question:

          #{@context}
        CONTEXT
      }
    end

    messages.concat(
      @conversation.messages.order(:created_at).map do |message|
        {
          role: message.role,
          content: message.content
        }
      end
    )

    if @current_question.present?
      messages << {
        role: "user",
        content: current_question
      }
    end

    messages
  end
end
