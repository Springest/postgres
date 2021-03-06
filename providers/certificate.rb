#
# Cookbook Name:: postgres
# Provider:: certificate
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

  certificate_manage new_resource.name do
    cert_path         node['postgres']['data_dir']
    owner             node['postgres']['user']['name']
    group             node['postgres']['user']['group']
    key_file          'server.key'
    cert_file         'server.crt'
    create_subfolders false

    data_bag        new_resource.data_bag        if new_resource.data_bag
    data_bag_secret new_resource.data_bag_secret if new_resource.data_bag_secret
    cookbook        new_resource.cookbook        if new_resource.cookbook

    notifies        :restart, 'service[postgresql]', :immediately
  end
end
