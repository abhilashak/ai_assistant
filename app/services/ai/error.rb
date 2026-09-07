class Ai::Error < StandardError
end

class Ai::ProviderError < Ai::Error
end

class Ai::RateLimitError < Ai::Error
end

class Ai::TimeoutError < Ai::Error
end
