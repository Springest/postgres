#
# Cookbook Name:: postgres
# Provider:: recovery
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

action :create do
  service 'postgresql' do
    service_name node['postgres']['service_name']
    supports :restart => true, :status => true, :reload => true
    action   :nothing
  end

  path = "#{node['postgres']['data_dir']}/recovery.conf"

  # check if this node is a postgres slave
  is_slave = ::File.exists? path

  # use .done as file extension, if this node is a postgres master
  path.sub!(/\.[^\.]+$/, '.done') unless is_slave

  template path do
    mode      '0644'
    owner     node['postgres']['user']['name']
    group     node['postgres']['user']['group']

    cookbook  new_resource.cookbook
    source    new_resource.source
    variables new_resource.variables

    notifies  :reload, 'service[postgresql]', :immediately if is_slave
  end
end
