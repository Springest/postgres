#
# Cookbook Name:: postgres
# Attributes:: default_config
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
include_attribute 'postgresql::default'

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
