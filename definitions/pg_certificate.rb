#
# Cookbook Name:: postgresql
# Definition:: pg_certificate
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

class Chef::Recipe
  include Postgresql::Helpers
end


define :pg_certificate, :action => :create do
  include_recipe 'postgresql::install_server'

  # use defaults unless overridden
  params[:cert_path] ||= node['postgresql']['data_dir']
  params[:owner] ||= node['postgresql']['db_user']
  params[:group] ||= node['postgresql']['db_group']

  certificate_manage params[:name] do
    search_id params[:name]
    cert_path params[:cert_path]
    owner     params[:owner]
    group     params[:group]
    key_file  'server.key'
    cert_file 'server.crt'
    notifies  :reload, resources(:service => 'postgresql')
  end
end
