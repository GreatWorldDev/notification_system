class Rack::Attack
  # Throttle API requests by IP address
  throttle("api/ip", limit: 60, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api")
  end

  # Throttle notification create by user_id
  throttle("notifications/user", limit: 15, period: 1.minute) do |req|
    if req.path == "/api/notifications" && req.post?
      req.params["user_id"]
    end
  end

  # Throttle notification create by group_id
  throttle("notifications/group", limit: 5, period: 1.minute) do |req|
    if req.path == "/api/notifications" && req.post?
      req.params["group_id"]
    end
  end

  # Configure Redis for storing throttle data
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV["REDIS_URL"] || "redis://localhost:6379/0",
    expires_in: 90.seconds,
  )
end

Rails.application.config.middleware.use Rack::Attack
