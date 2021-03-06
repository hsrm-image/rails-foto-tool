require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsFotoTool
	class Application < Rails::Application
		# Initialize configuration defaults for originally generated Rails version.
		config.load_defaults 6.1

		# Configuration for the application, engines, and railties goes here.
		#
		# These settings can be overridden in specific environments using the files
		# in config/environments, which are processed later.
		#
		# config.time_zone = "Central Time (US & Canada)"
		# config.eager_load_paths << Rails.root.join("extras")

		# Set the available locales
		I18n.available_locales = %i[en de]

		# Set the default locale
		I18n.default_locale = :en

		# Set the maximum filesize for images
		config.x.image.max_file_size = 50.megabyte

		# Please edit this variable to reflect the URL of the Server
		config.x.mail.root_url = 'localhost:3000'

		# The mail address the Server should send mails from
		config.x.mail.sender_address = 'please@change-me.com'

		# Change the size of the preview images on the main page (changing this causes all images to rerender)
		config.x.image.preview_image_size = 800
	end
end
