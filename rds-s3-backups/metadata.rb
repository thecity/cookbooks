maintainer       "The City"
maintainer_email "jonathan@onthecity.org"
license          "Apache 2.0"
description      "Installs/Configures rds-s3-backups"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "rds-s3-backups", "Scheduled backups of RDS server snapshot"

%w{ ubuntu debian }.each do |os|
  supports os
end
