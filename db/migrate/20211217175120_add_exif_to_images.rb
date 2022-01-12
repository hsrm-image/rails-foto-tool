class AddExifToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :exif_camera_maker, :string, null: true
    add_column :images, :exif_camera_model, :string, null: true
    add_column :images, :exif_lens_model, :string, null: true
    add_column :images, :exif_focal_length, :float, null: true
    add_column :images, :exif_aperture, :float, null: true
    add_column :images, :exif_exposure, :string, null: true
    add_column :images, :exif_iso, :integer, null: true
    add_column :images, :exif_gps_latitude, :double, null: true
    add_column :images, :exif_gps_longitude, :double, null: true
  end
end
