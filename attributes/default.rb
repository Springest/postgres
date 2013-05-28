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
    default['postgres']['version'] = '8.3'
  when platform_version.to_f == 6.0
    default['postgres']['version'] = '8.4'
  else
    default['postgres']['version'] = '9.1'
  end

  default['postgres']['user']['name'] = 'postgres'
  default['postgres']['user']['group'] = 'postgres'
  default['postgres']['user']['home'] = '/var/lib/postgresql'
  default['postgres']['conf_dir'] = "/etc/postgresql/#{node['postgres']['version']}/main"
  default['postgres']['data_dir'] = "/var/lib/postgresql/#{node['postgres']['version']}/main"
  default['postgres']['contrib_dir'] = "/usr/share/postgresql/#{node['postgres']['version']}/contrib"
  if platform_version.to_f <= 5.0
    default['postgres']['service_name'] = "postgresql-#{node['postgres']['version']}"
  else
    default['postgres']['service_name'] = 'postgresql'
  end
  default['postgres']['client_packages'] = [ "postgresql-client-#{node['postgres']['version']}", 'libpq-dev' ]
  default['postgres']['server_packages'] = [ "postgresql-#{node['postgres']['version']}" ]
  default['postgres']['contrib_packages'] = [ "postgresql-contrib-#{node['postgres']['version']}" ]


when 'ubuntu'

  case
  when platform_version.to_f <= 9.04
    default['postgres']['version'] = '8.3'
  when platform_version.to_f <= 11.04
    default['postgres']['version'] = '8.4'
  else
    default['postgres']['version'] = '9.1'
  end

  default['postgres']['user']['name'] = 'postgres'
  default['postgres']['user']['group'] = 'postgres'
  default['postgres']['user']['home'] = '/var/lib/postgresql'
  default['postgres']['conf_dir'] = "/etc/postgresql/#{node['postgres']['version']}/main"
  default['postgres']['data_dir'] = "/var/lib/postgresql/#{node['postgres']['version']}/main"
  default['postgres']['contrib_dir'] = "/usr/share/postgresql/#{node['postgres']['version']}/contrib"
  if platform_version.to_f <= 10.04
    default['postgres']['service_name'] = "postgresql-#{node['postgres']['version']}"
  else
    default['postgres']['service_name'] = 'postgresql'
  end
  default['postgres']['client_packages'] = [ "postgresql-client-#{node['postgres']['version']}", 'libpq-dev' ]
  default['postgres']['server_packages'] = [ "postgresql-#{node['postgres']['version']}" ]
  default['postgres']['contrib_packages'] = [ "postgresql-contrib-#{node['postgres']['version']}" ]

when 'redhat', 'centos', 'scientific', 'amazon'

  default['postgres']['version'] = '8.4'
  default['postgres']['user']['name'] = 'postgres'
  default['postgres']['user']['group'] = 'postgres'
  default['postgres']['user']['home'] = '/var/lib/pgsql'
  default['postgres']['conf_dir'] = '/var/lib/pgsql/data'
  default['postgres']['data_dir'] = '/var/lib/pgsql/data'
  default['postgres']['contrib_dir'] = "/usr/share/pgsql/contrib"
  default['postgres']['service_name'] = 'postgresql'

  if node['platform_version'].to_f >= 6.0
    default['postgres']['client_packages'] = [ 'postgresql-devel' ]
    default['postgres']['server_packages'] = [ 'postgresql-server' ]
    default['postgres']['contrib_packages'] = [ 'postgresql-contrib' ]
  else
    default['postgres']['client_packages'] = [ "postgresql#{node['postgres']['version'].split('.').join}-devel" ]
    default['postgres']['server_packages'] = [ "postgresql#{node['postgres']['version'].split('.').join}-server" ]
    default['postgres']['contrib_packages'] = [ "postgresql#{node['postgres']['version'].split('.').join}-contrib" ]
  end

end


# by default, don't use ssl certificates
default['postgres']['certificate'] = false
