#
# Cookbook Name:: postgres
# Provider:: xc_gtm
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

  execute "initgtm -D #{dir} -Z gtm" do
    user    node['postgres']['user']['name']
    creates "#{dir}/gtm.conf"
  end

  template "#{dir}/gtm.conf" do
    cookbook  'postgres'
    source    'xc/gtm.conf.erb'
    variables :nodename => new_resource.nodename,
              :listen_addresses => new_resource.listen_addresses,
              :port => new_resource.port,
              :startup => new_resource.startup
  end
end
