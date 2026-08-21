class MessagesController < ApplicationController
  def create
    conversation = Conversation.find(params[:conversation_id])

    Ai::ChatService.new.call(
      conversation: conversation,
      user_message: params.require(:content)
    )

    redirect_to conversation_path(conversation)
  end
end
