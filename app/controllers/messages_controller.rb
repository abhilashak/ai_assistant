class MessagesController < ApplicationController
  include ActionController::Live

  def create
    conversation = Conversation.find(params[:conversation_id])

    redirect_to conversation_path(conversation)
  end

  def stream
    conversation = Conversation.find(params[:conversation_id])
    user_message = params.require(:content)

    response.headers["Content-Type"] = "text/event-stream"
    response.headers["Cache-Control"] = "no-cache"
    response.headers["X-Accel-Buffering"] = "no"

    sse = SSE.new(response.stream)

    begin
      conversation.messages.create!(
        role: :user,
        content: user_message
      )

      messages = Ai::PromptBuilder.new(conversation: conversation).build
      full_response = +""

      usage = Ai::Client.new.stream_chat(messages: messages) do |delta|
        next if delta.blank?

        full_response << delta

        sse.write(
          { content: delta },
          event: "message"
        )
      end

      conversation.messages.create!(
        role: :assistant,
        content: full_response,
        model: usage[:model],
        input_tokens: usage[:input_tokens],
        output_tokens: usage[:output_tokens]
      )

      sse.write(
        { done: true },
        event: "done"
      )
    rescue IOError
      Rails.logger.debug(">>>>>>>>>>>>>> Error Occured: IOError")
    rescue ActionController::Live::ClientDisconnected
      Rails.logger.debug(">>>>>>>>>>>>>> SSE client disconnected")
    ensure
      sse.close
    end
  end
end
