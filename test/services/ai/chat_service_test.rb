require "test_helper"

class Ai::ChatServiceTest < ActiveSupport::TestCase
  test "persists user and assistant messages" do
    conversation = Conversation.create!(title: "Test")

    fake_client = Minitest::Mock.new

    fake_client.expect(
      :chat,
      {
        content: "Ruby is a programming language.",
        model: "test-model",
        input_tokens: 10,
        output_tokens: 8
      },
      message: "What is Ruby?"
    )

    service = Ai::ChatService.new(ai_client: fake_client)

    service.call(
      conversation: conversation,
      user_message: "What is Ruby?"
    )

    assert_equal 2, conversation.messages.count

    user_message = conversation.messages.user.first
    assistant_message = conversation.messages.assistant.first

    assert_equal "What is Ruby?", user_message.content
    assert_equal "Ruby is a programming language.", assistant_message.content
    assert_equal "test-model", assistant_message.model
    assert_equal 10, assistant_message.input_tokens
    assert_equal 8, assistant_message.output_tokens

    fake_client.verify
  end
end
