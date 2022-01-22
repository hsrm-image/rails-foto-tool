require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # This enables session_ids in tests. 
  # you CANNOT imagine how long this took me to find out...
  ActionController::Base.allow_forgery_protection = true
  Rails.configuration.assets.debug = true # TODO???

  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  include ActiveJob::TestHelper 
end
