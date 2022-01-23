require "test_helper"

#---------------------------------------------------------------------
# Please DO NOT run system and normal tests at the same time!
# Instead run the normal test using 'rails test'
# And System tests using 'rails test test/system'
# This is caused by the System tests requiring a session cookie
# But setting
# ActionController::Base.allow_forgery_protection = true
# in the system tests overwrites the setting inside the test_helper
#---------------------------------------------------------------------


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # This enables session_ids in tests. 
  # you CANNOT imagine how long this took me to find out...
  # WARNING: only works for system tests (See text above)
  ActionController::Base.allow_forgery_protection = true

  # This is not required for the actual tests but makes the page look better for debugging
  #Rails.configuration.assets.debug = true 

  # This is kinda high but my VM sometimes struggles with tight wait times.....
  Capybara.default_max_wait_time = 10

  # For the mailer
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  include ActiveJob::TestHelper 
end
