#
# Cookbook Name:: postgres
# Recipe:: default_server
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

# install packages
include_recipe 'postgresql::client'
node['postgresql']['server_packages'].each { |pkg| package pkg }


# setup directories
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
  owner     node['postgresql']['db_user']
  group     node['postgresql']['db_group']
  mode      '0644'
  cookbook  'postgresql'
  source    'postgresql.conf.erb'
  variables :config => node['postgresql']['postgresql.conf']
  notifies  :restart, resources(:service => 'postgresql')
end

template 'pg_hba.conf' do
  path      "#{node['postgresql']['conf_dir']}/pg_hba.conf"
  owner     node['postgresql']['db_user']
  group     node['postgresql']['db_group']
  mode      '0640'
  cookbook  'postgresql'
  source    'pg_hba.conf.erb'
  variables :config => node['postgresql']['pg_hba.conf']
  notifies  :reload, resources(:service => 'postgresql')
end

template 'pg_ident.conf' do
  path      "#{node['postgresql']['conf_dir']}/pg_ident.conf"
  owner     node['postgresql']['db_user']
  group     node['postgresql']['db_group']
  mode      '0640'
  cookbook  'postgresql'
  source    'pg_ident.conf.erb'
  variables :config => node['postgresql']['pg_ident.conf']
  notifies  :reload, resources(:service => 'postgresql')
end


if node['postgresql']['certificate']
  # by default, use the certificate for this hostname
  if node['postgresql']['certificate'].to_s == 'true'
    certificate = node['hostname']
  else
    certificate = node['postgresql']['certificate']
  end

  certificate_manage 'certificate' do
    search_id certificate
    cert_path node['postgresql']['data_dir']
    owner     node['postgresql']['db_user']
    group     node['postgresql']['db_group']
    key_file  'server.key'
    cert_file 'server.crt'
    notifies  :reload, resources(:service => 'postgresql')
  end
end


template 'recovery.conf' do
  # only deploy recovery.conf to the slave
  if File.exists? "#{node['postgresql']['data_dir']}/recovery.conf"
    path    "#{node['postgresql']['data_dir']}/recovery.conf"
    notifies :reload, resources(:service => 'postgresql')
  else
    path    "#{node['postgresql']['data_dir']}/recovery.done"
  end

  owner     node['postgresql']['db_user']
  group     node['postgresql']['db_group']
  mode      '0644'
  cookbook  'postgresql'
  source    'recovery.conf.erb'
  variables :config => node['postgresql']['recovery.conf']
  not_if    { node['postgresql']['recovery.conf'].empty? }
end
