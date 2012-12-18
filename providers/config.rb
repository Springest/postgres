#
# Cookbook Name:: postgresql
# Provider:: config
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

  service 'postgresql' do
    service_name node['postgresql']['service_name']
    supports :restart => true, :status => true, :reload => true
    action   :enable
  end

  template 'postgresql.conf' do
    path      "#{node['postgresql']['conf_dir']}/postgresql.conf"
    mode      '0640'
    owner     node['postgresql']['db_user']
    group     node['postgresql']['db_group']

    cookbook  new_resource.cookbook
    source    new_resource.source
    variables new_resource.variables

    notifies  :reload, resources(:service => 'postgresql'), :immediately
  end
end
