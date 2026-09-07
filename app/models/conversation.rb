class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :ai_requests, dependent: :nullify
end
