CarrierWave.configure do |config|
  config.storage = :grid_fs

  # Storage access url
  config.grid_fs_access_url = "/upload/grid"
end