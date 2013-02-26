#
# Cookbook Name:: postgres
# Provider:: server_config
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
    action   :enable
  end

  template 'postgresql.conf' do
    path      "#{node['postgres']['conf_dir']}/postgresql.conf"
    mode      '0640'
    owner     node['postgres']['user']['name']
    group     node['postgres']['user']['group']

    cookbook  new_resource.cookbook
    source    new_resource.source
    variables new_resource.variables

    notifies  :reload, resources(:service => 'postgresql'), :immediately
  end
end
