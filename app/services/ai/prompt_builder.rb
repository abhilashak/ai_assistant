class Ai::PromptBuilder
  SYSTEM_PROMPT = <<~PROMPT
    You are a helpful AI assistant.
    Answer clearly and concisely.
    If you are unsure about something, say so.
  PROMPT

  def initialize(conversation:)
    @conversation = conversation
  end

  def build
    [
      {
        role: "system",
        content: SYSTEM_PROMPT.strip
      },
      *@conversation.messages.order(:created_at).map do |message|
        {
          role: message.role,
          content: message.content
        }
      end
    ]
  end
end
