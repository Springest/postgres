#
# Cookbook Name:: postgres
# Provider:: extension
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

action :install do
  execute "pgxn install #{new_resource.package}" do
    not_if "test -f #{node['postgres']['contrib_dir']}/../extension/#{new_resource.package}.control"
  end
end

action :uninstall do
  execute "pgxn install #{new_resource.package}" do
    only_if "test -f #{node['postgres']['contrib_dir']}/../extension/#{new_resource.package}.control"
  end
end
