require "test_helper"
require 'fileutils'

class AnalyseImageJobTest < ActiveJob::TestCase
  setup do
    @image = images(:processing)
    @file_path = ActiveSupport::TestCase.reset_image_two(@image)
  end

  test "should enqueue job" do
    assert_enqueued_jobs 1 do
      AnalyseImageJob.perform_later(@image)
    end

    perform_enqueued_jobs
  end

  test "should perform job" do
    perform_enqueued_jobs do
      AnalyseImageJob.perform_later(@image)
    end

    assert_no_enqueued_jobs only: AnalyseImageJob
    assert_performed_jobs 1, only: AnalyseImageJob
  end

  test "should extract exif" do
    perform_enqueued_jobs do
      AnalyseImageJob.perform_later(@image)
    end

    # Reload image file
    @image = Image.find(images(:processing).id)
    exif = MiniMagick::Image.open(@file_path).exif

    assert_equal(exif["PhotographicSensitivity"].to_s, @image.exif_iso.to_s)
    assert_equal(exif["Make"], @image.exif_camera_maker)
  end

  test "should strip exif" do
    perform_enqueued_jobs do
      AnalyseImageJob.perform_later(@image)
    end
    # Reload image file
    @image = Image.find(images(:processing).id)
    exif = MiniMagick::Image.open(@image.image_file).exif

    assert_nil(exif["PhotographicSensitivity"])
    assert_nil(exif["Make"])
  end

  teardown do
    # Reload image file
    @image = Image.find(images(:processing).id)

    # Delete created folders
    FileUtils.rm_rf(File.dirname(File.dirname(ActiveStorage::Blob.service.path_for(@image.image_file.key))))
  end
end
