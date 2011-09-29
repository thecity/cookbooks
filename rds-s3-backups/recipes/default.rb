# Author:: Jonathan Owens <jonathan@onthecity.org>
# Cookbook Name:: rds-backup-replica
# Recipe:: default
#
# Copyright 2011, ACS Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'ruby' do 
  action :install
end

package 'rubygems' do 
  action :install
end

package 'mysql-client' do 
  action :install
end

package 'libxml2-dev' do
  action :install
end

package 'libxslt1-dev' do
  action :install
end

if `gem --version` =~ /1.3.5/
  # Ubuntu 10.04 has an old-ass rubygems and gem update --system doesn't work.
  
  gem_package 'rubygems-update' do 
    action :install
  end
    
  execute 'update_rubygems' do
    command '/usr/bin/update_rubygems'
    action :run
  end
end

gem_package 'fog' do 
  action :install
end

gem_package 'thor' do
  action :install
end

gem_package 'cocaine' do
  action :install
end


remote_file '/usr/local/bin/rds-s3-backup.rb' do 
  source 'https://raw.github.com/thecity/rds-s3-backup/master/rds-s3-backup.rb'
  action :create
  owner 'root'
  group 'root'
  mode 00755
end

template '/etc/rds-s3-configuration.yml' do
  source 'rds-s3-configuration.yml.erb'
  variables(
    :aws_creds   => Chef::EncryptedDataBagItem.load("aws_credentials",      node[:rds_s3_backups][:environment]),
    :mysql_creds => Chef::EncryptedDataBagItem.load("database_credentials", node[:rds_s3_backups][:environment])
  )
  owner 'root'
  group 'root'
  mode 00755
end
  

cron "rds-backup" do
  hour node[:rds_s3_backups][:cron_start_hour]
  minute node[:rds_s3_backups][:cron_start_minute]
  path "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin"
  
  command "ruby /usr/local/bin/rds-s3-backup.rb s3_dump --config-file=/etc/rds-s3-configuration.yml 2>&1"
end
