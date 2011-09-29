default[:rds_s3_backups][:rds_instance_id] = ''
default[:rds_s3_backups][:s3_bucket]       = ''
default[:rds_s3_backups][:mysql_database]  = ''
default[:rds_s3_backups][:environment]     = 'staging'
default[:rds_s3_backups][:dump_ttl]        = 40
default[:rds_s3_backups][:cron_start_hour] = '04'
default[:rds_s3_backups][:cron_start_minute] = '00'