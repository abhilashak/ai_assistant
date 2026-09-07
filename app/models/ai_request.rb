class AiRequest < ApplicationRecord
  belongs_to :conversation, optional: true
  belongs_to :message, optional: true

  enum :status, {
    pending: "pending",
    success: "success",
    failed: "failed",
    rate_limited: "rate_limited",
    timeout: "timeout"
  }, validate: true

  validates :provider, :model, :operation, :status, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :successful, -> { where(status: :success) }
  scope :failed_requests, -> { where.not(status: :success) }

  def duration_seconds
    return unless latency_ms

    latency_ms / 1000.0
  end

  def total_tokens
    input_tokens.to_i + output_tokens.to_i
  end
end
