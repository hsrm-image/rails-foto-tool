ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'fileutils'

class ActiveSupport::TestCase
  def self.reset_image_one(image)
    image_one = Rails.root.join('test', 'fixtures', 'files', 'test.png')
    dst = Rails.root.join('tmp', 'storage', 'ip', 'm7', 'ipm7ibsg23csmekv3mqhfftxjdih')
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(image_one, dst)
    return image_one
  end

  def self.reset_image_two(image)
    image_two = Rails.root.join('test', 'fixtures', 'files', 'exif.jpg')
    dst = Rails.root.join('tmp', 'storage', '2a', 'z6', '2az6wccbpbjuv09zb78mkwf9pysm')
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

  def log_in(user)
    if integration_test?
      login_as(user, :scope => :user)
    else
      sign_in(user)
    end
  end


end
