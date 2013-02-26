#
# Cookbook Name:: postgres
# Recipe:: pkg-install-server
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

node['postgresql']['server_packages'].each { |pkg| package pkg }

unless node['postgresql']['conf_dir'] == node['postgresql']['data_dir']
  directory node['postgresql']['conf_dir'] do
    owner     node['postgresql']['db_user']
    group     node['postgresql']['db_group']
    mode      '0755'
  end
end

directory node['postgresql']['data_dir'] do
  owner     node['postgresql']['db_user']
  group     node['postgresql']['db_group']
  mode      '0700'
end
