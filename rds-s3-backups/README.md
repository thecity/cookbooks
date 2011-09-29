DESCRIPTION
===========

This cookbook is used to schedule running the rds-s3-backups script every day at 4:00AM.

REQUIREMENTS
============

Chef 0.10.0 or later is required.

Supported Platforms
-------------------

The following platforms are supported by this cookbook.

* Debian
* Ubuntu

ATTRIBUTES
==========

* `node[:rds_s3_backups][:rds_instance_id]` - The rds server you want to clone and dump from.
* `node[:rds_s3_backups][:s3_bucket]` - The s3 bucket you'll be storing your dumps in. The script puts them in db_backups/
* `node[:rds_s3_backups][:mysql_database]` - The database on the server you want to have dumped.
* `node[:rds_s3_backups][:environment]` - The set of credentials to use for AWS and the database. Default 'staging'.
* `node[:rds_s3_backups][:dump_ttl]` - The number of dump files to keep in S3. Default 40.
* `node[:rds_s3_backups][:cron_start_hour]` - The hour of the day to start the backup run. Default 04.
* `node[:rds_s3_backups][:cron_start_minute]` - The minute of the day to start the backup run. Default 00.

RECIPES
=======

default
-------

Installs the `/usr/local/bin/rds-s3-backup.rb` script from GitHub and configures it to run via cron at 0400. 

USAGE
=====

Create a role for your backup server(s) that define behaviors that all your servers will share. This usually is just the s3 bucket but could be even less.

You must define at least 
 * rds_instance_id
 * s3_bucket
 * mysql_database
 * environment

on each node, along with encrypted data bags "aws_credentials" and "database_credentials", which contain:

  { 
    "id": "<your environment>",
    "access_key_id": "<your encrypted access key>",
    "secret_access_key": "<your encrypted secret key>"
  }

and 

  { 
    "id": "<node[:rds_s3_backups][:environment]>",
    "username": "<your encrypted mysql username>",
    "password": "<your encrypted mysql password>"
  }
  
respectively, along with loading your encrypted data bag secret in the default /etc/chef/encrypted_data_bag_secret location.

The recipe will load your AWS credentials and database credentials in the script configuration file onto your nodes in cleartext! 

TEMPLATES
=========

rds-s3-configuration.yml.erb
----------------------------

YAML configuration for the rds-s3-backup script, lands in `/etc/`.

LICENSE AND AUTHORS
===================

* Author: Jonathan Owens <jonathan@onthecity.org>
* Copyright 2011, ACS Technologies

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
