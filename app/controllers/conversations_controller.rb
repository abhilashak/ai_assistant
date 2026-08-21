class ConversationsController < ApplicationController
  def new
    @conversation = Conversation.new
  end

  def create
    @conversation = Conversation.create!(
      title: params[:title].presence || "New conversation"
    )

    redirect_to conversation_path(@conversation)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(:created_at)
  end
end
