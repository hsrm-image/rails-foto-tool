class AnalyseImageJob < ApplicationJob
  queue_as :default

  def perform(image)
    exif = MiniMagick::Image.open(image.image_file).exif

    # Because this runs as a background job, only replace empty values (As not to overwrite already user-defined values)
    image.exif_camera_maker  ||= exif["Make"]
    image.exif_camera_model  ||= exif["Model"]
    image.exif_lens_model    ||= exif["LensModel"]
    image.exif_exposure      ||= exif["ExposureTime"]
    image.exif_iso           ||= exif["PhotographicSensitivity"]

    # Only analyse these two if existent (otherwise 0.0 will be written to DB)
    image.exif_focal_length  ||= exif["FocalLength"]&.to_r&.to_f
    image.exif_aperture      ||= exif["FNumber"]&.to_r&.to_f
    
    # GPS values arrive as a comma-separated list of 3 rationals: Degrees, Minutes, seconds (https://exif.org/Exif2-2.PDF Page 53)
    # eg. "8/1, 106236750/10000000, 0/1"
    # To convert this format we first extract the numbers and then convert it to Decimal Degrees because the database likes numbers more than strings :)
    unless(exif["GPSLatitude"].nil? or exif["GPSLongitude"].nil?)
      d, m, s = exif["GPSLatitude"].split(", ").map{ |x| x.to_r } 
      image.exif_gps_latitude  ||= d + m / 60 + s / 3600
      d, m, s = exif["GPSLongitude"].split(", ").map{ |x| x.to_r } 
      image.exif_gps_longitude ||= d + m / 60 + s / 3600
    end

    file = MiniMagick::Image.open(image.image_file)
    file.auto_orient # Turn the image if neccessary
    file.strip # Strip Exif
    image.image_file.attach(io: StringIO.open(file.to_blob), filename: image.image_file.blob.filename.to_s)

    image.processed = true

    image.save!
  end
end
