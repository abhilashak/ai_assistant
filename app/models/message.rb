class Message < ApplicationRecord
  belongs_to :conversation

  enum :role, {
    user: "user",
    assistant: "assistant",
    system: "system"
  }, validate: true
end
