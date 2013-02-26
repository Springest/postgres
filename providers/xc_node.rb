#
# Cookbook Name:: postgres
# Provider:: xc_coordinator
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
  dir = "#{node['postgres']['xc']['data_dir']}/#{new_resource.nodename}"

  execute "initdb -D #{dir} --nodename #{new_resource.nodename}" do
    user    node['postgres']['user']['name']
    creates "#{dir}/postgresql.conf"
  end

  template "#{dir}/postgresql.conf" do
    cookbook  new_resource.cookbook
    source    new_resource.source

    if new_resource.variables.empty?
      variables :nodename => new_resource.nodename,
                :listen_addresses => new_resource.listen_addresses,
                :port => new_resource.port,
                :pooler_port => new_resource.pooler_port,
                :gtm_host => new_resource.gtm_host,
                :gtm_port => new_resource.gtm_port,
                :max_connections => new_resource.max_connections,
                :shared_buffers => new_resource.shared_buffers
    else
      variables new_resource.variables
    end
  end
end
