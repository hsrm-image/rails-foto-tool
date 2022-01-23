ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fileutils'

#---------------------------------------------------------------------
# Please DO NOT run system and normal tests at the same time!
# Instead run the normal test using 'rails test'
# And System tests using 'rails test test/system'
# This is caused by the System tests requiring a session cookie
# But setting
# ActionController::Base.allow_forgery_protection = true
# in the system tests overwrites the setting inside the test_helper
#---------------------------------------------------------------------

class ActiveSupport::TestCase
	ActionDispatch::IntegrationTest.app.default_url_options[:locale] =
		I18n.locale

	def self.reset_image_one(image)
		image_one = Rails.root.join('test', 'fixtures', 'files', 'test.png')
		dst =
			Rails.root.join(
				'tmp',
				'storage',
				'ip',
				'm7',
				'ipm7ibsg23csmekv3mqhfftxjdih',
			)
		FileUtils.mkdir_p(File.dirname(dst))
		FileUtils.cp(image_one, dst)
		return image_one
	end

	def self.reset_image_two(image)
		image_two = Rails.root.join('test', 'fixtures', 'files', 'exif.jpg')
		dst =
			Rails.root.join(
				'tmp',
				'storage',
				'2a',
				'z6',
				'2az6wccbpbjuv09zb78mkwf9pysm',
			)
		FileUtils.mkdir_p(File.dirname(dst))
		FileUtils.cp(image_two, dst)
		reload_blob(image, image_two)
		return image_two
	end

	def self.reload_blob(image, file)
		return if image.nil?
		image.image_file.blob.byte_size = File.size(file)
		image.image_file.blob.checksum = Digest::MD5.file(file).base64digest
		image.save!
	end

	self.reset_image_one(nil)
	self.reset_image_two(nil)

	# Run tests in parallel with specified workers
	parallelize(workers: :number_of_processors)

	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
	fixtures :all

	include Devise::Test::IntegrationHelpers
	include Warden::Test::Helpers

	# For mailers
	Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end
