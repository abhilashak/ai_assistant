class Admin::AiRequestsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @ai_requests = AiRequest
      .includes(:conversation, :message)
      .recent
      .limit(100)

    @total_requests       = AiRequest.count
    @successful_requests  = AiRequest.successful.count
    @failed_requests      = AiRequest.failed_requests.count
    @total_input_tokens   = AiRequest.sum(:input_tokens)
    @total_output_tokens  = AiRequest.sum(:output_tokens)
    @average_latency      = AiRequest.where.not(latency_ms: nil).average(:latency_ms)
    @estimated_cost       = AiRequest.sum(:estimated_cost)
  end

  def show
    @ai_request = AiRequest.includes(
      :conversation,
      :message
    ).find(params[:id])
  end

  private

  def authenticate_admin!
    authenticate_or_request_with_http_basic("AI Admin") do |username, password|
      username == Rails.application.credentials.dig(:admin, :username) &&
        password == Rails.application.credentials.dig(:admin, :password)
    end
  end
end
