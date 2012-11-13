#
# Cookbook Name:: postgres
# Attributes:: default
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# some default attributes stolen from
# https://github.com/opscode-cookbooks/postgresql/blob/master/attributes/default.rb
case platform
when 'debian'

  case
  when platform_version.to_f <= 5.0
    default['postgresql']['version'] = '8.3'
  when platform_version.to_f == 6.0
    default['postgresql']['version'] = '8.4'
  else
    default['postgresql']['version'] = '9.1'
  end

  default['postgresql']['db_user'] = 'postgres'
  default['postgresql']['db_group'] = 'postgres'
  default['postgresql']['conf_dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"
  default['postgresql']['data_dir'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main"
  if platform_version.to_f <= 5.0
    default['postgresql']['service_name'] = "postgresql-#{node['postgresql']['version']}"
  else
    default['postgresql']['service_name'] = 'postgresql'
  end
  default['postgresql']['client_packages'] = [ "postgresql-client-#{node['postgresql']['version']}", 'libpq-dev' ]
  default['postgresql']['server_packages'] = [ "postgresql-#{node['postgresql']['version']}" ]
  default['postgresql']['contrib_packages'] = [ "postgresql-contrib-#{node['postgresql']['version']}" ]


when 'ubuntu'

  case
  when platform_version.to_f <= 9.04
    default['postgresql']['version'] = '8.3'
  when platform_version.to_f <= 11.04
    default['postgresql']['version'] = '8.4'
  else
    default['postgresql']['version'] = '9.1'
  end

  default['postgresql']['db_user'] = 'postgres'
  default['postgresql']['db_group'] = 'postgres'
  default['postgresql']['conf_dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"
  default['postgresql']['data_dir'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main"
  if platform_version.to_f <= 10.04
    default['postgresql']['service_name'] = "postgresql-#{node['postgresql']['version']}"
  else
    default['postgresql']['service_name'] = 'postgresql'
  end
  default['postgresql']['client_packages'] = [ "postgresql-client-#{node['postgresql']['version']}", 'libpq-dev' ]
  default['postgresql']['server_packages'] = [ "postgresql-#{node['postgresql']['version']}" ]
  default['postgresql']['contrib_packages'] = [ "postgresql-contrib-#{node['postgresql']['version']}" ]

when 'redhat', 'centos', 'scientific'

  default['postgresql']['version'] = '8.4'
  default['postgresql']['db_user'] = 'postgres'
  default['postgresql']['db_group'] = 'postgres'
  default['postgresql']['conf_dir'] = '/var/lib/pgsql/data'
  default['postgresql']['data_dir'] = '/var/lib/pgsql/data'
  default['postgresql']['service_name'] = 'postgresql'

  if node['platform_version'].to_f >= 6.0
    default['postgresql']['client_packages'] = [ 'postgresql-devel' ]
    default['postgresql']['server_packages'] = [ 'postgresql-server' ]
    default['postgresql']['contrib_packages'] = [ 'postgresql-contrib' ]
  else
    default['postgresql']['client_packages'] = [ "postgresql#{node['postgresql']['version'].split('.').join}-devel" ]
    default['postgresql']['server_packages'] = [ "postgresql#{node['postgresql']['version'].split('.').join}-server" ]
    default['postgresql']['contrib_packages'] = [ "postgresql#{node['postgresql']['version'].split('.').join}-contrib" ]
  end

end


# default postgresql.conf settings
default['postgresql']['postgresql.conf'] = {
  'max_connections' => 100,
  'datestyle' => 'iso, mdy',
  'lc_messages' => 'en_US.UTF-8',
  'lc_monetary' => 'en_US.UTF-8',
  'lc_numeric' => 'en_US.UTF-8',
  'lc_time' => 'en_US.UTF-8',
  'default_text_search_config' => 'pg_catalog.english',
  'log_line_prefix' => '%t [%p] %u@%d ',
  'data_directory' => node['postgresql']['data_dir']
}

# default pg_hba.conf settings
default['postgresql']['pg_hba.conf'] =  [ 'local all postgres trust' ]

# default pg_ident.conf settings
default['postgresql']['pg_ident.conf'] = []

# default recovery.conf settings
default['postgresql']['recovery.conf'] = {}

# per default, don't use ssl certificates
default['postgresql']['certificate'] = false
