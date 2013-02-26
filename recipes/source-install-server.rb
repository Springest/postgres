#
# Cookbook Name:: postgres
# Recipe:: source-install-server
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

# TODO
# install from source

# create user, group and directories

group node['postgres']['user']['group'] do
  system true
end

user node['postgres']['user']['name'] do
  gid    node['postgres']['user']['group']
  home   node['postgres']['user']['home']
  system true
end

directory node['postgres']['user']['home'] do
  owner     node['postgres']['user']['name']
  group     node['postgres']['user']['group']
  mode      '0755'
end

directory node['postgres']['conf_dir'] do
  owner     node['postgres']['user']['name']
  group     node['postgres']['user']['group']
  mode      '0755'
  recursive true
  not_if  { node['postgres']['conf_dir'] == node['postgres']['data_dir'] }
end

directory node['postgres']['data_dir'] do
  owner     node['postgres']['user']['name']
  group     node['postgres']['user']['group']
  mode      '0700'
  recursive true
end
