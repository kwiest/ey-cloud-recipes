# Modify the warning and failure limits to fit your needs

collectd_disk_alert do
  disk :data
  warning '1572864000.0' # 1.5GB
  failure '524288000.0' # 500MB
end
