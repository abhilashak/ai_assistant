class Message < ApplicationRecord
  belongs_to :conversation
  has_many :ai_requests, dependent: :nullify

  enum :role, {
    user: "user",
    assistant: "assistant",
    system: "system"
  }, validate: true
end
