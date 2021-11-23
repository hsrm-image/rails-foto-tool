# The session remains valid for 1 day
Rails.application.config.session_store :cookie_store, expire_after: 1.days
