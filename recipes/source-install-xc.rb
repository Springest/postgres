#
# Cookbook Name:: postgresql
# Recipe:: source-install-xc
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

package 'curl'
package 'build-essential'
package 'libssl-dev'
package 'libreadline6-dev'
package 'flex'
package 'bison'
package 'zlib1g-dev'

def install_postgres_xc
  tmpdir = %x[mktemp -d].chomp

  execute 'downloading postgres-xc' do
    cwd tmpdir
    command "curl #{node['postgresql']['xc']['url']} |tar -zxf -"
  end

  execute 'patching postgres-xc' do
    cwd "#{tmpdir}/pgxc-v#{node['postgresql']['xc']['version']}"
    command "curl #{node['postgresql']['xc']['postgis']['patch']} |patch -p1"
    only_if { node['postgresql']['xc']['postgis']['patch'] }
  end

  execute 'running configure' do
    cwd "#{tmpdir}/pgxc-v#{node['postgresql']['xc']['version']}"
    command "./configure --with-openssl --prefix=#{node['postgresql']['xc']['prefix']}"
  end

  execute 'compiling postgres-xc' do
    cwd "#{tmpdir}/pgxc-v#{node['postgresql']['xc']['version']}"
    command 'make && make install'
  end

  execute 'compiling postgres-xc (contrib)' do
    cwd "#{tmpdir}/pgxc-v#{node['postgresql']['xc']['version']}/contrib"
    command 'make && make install'
  end

  directory tmpdir do
    action :delete
    recursive true
  end
end

install_postgres_xc unless ::File.directory?(node['postgresql']['xc']['prefix'])

node.set['postgis']['pg_config'] = "#{node['postgresql']['xc']['prefix']}/bin/pg_config"
node.set['postgresql']['contrib_dir'] = "#{node['postgresql']['xc']['prefix']}/share/contrib"
node.set['postgresql']['xc']['enabled'] = true


# deploy init script
template '/etc/init.d/postgres-xc' do
  cookbook 'postgresql'
  source   'postgres-xc.init.erb'
  mode     '0755'
  # variables :logfile =>
  #           :conf_dir =>
end

# install logrotate rules
# logrotate_app 'postgres-xc' do
#   path '/var/log/postgres-xc/*.log'
#   options [ 'missingok', 'notifempty', 'copytruncate', 'compress' ]
#   frequency 'daily'
#   rotate 7
# end


# create user, group and directories

group node['postgresql']['user']['group'] do
  system true
end

user node['postgresql']['user']['name'] do
  gid    node['postgresql']['user']['group']
  home   node['postgresql']['user']['home']
  system true
end

directory node['postgresql']['user']['home'] do
  owner     node['postgresql']['user']['name']
  group     node['postgresql']['user']['group']
  mode      '0755'
end

directory node['postgresql']['conf_dir'] do
  owner     node['postgresql']['user']['name']
  group     node['postgresql']['user']['group']
  mode      '0755'
  recursive true
  not_if  { node['postgresql']['conf_dir'] == node['postgresql']['data_dir'] }
end

directory node['postgresql']['data_dir'] do
  owner     node['postgresql']['user']['name']
  group     node['postgresql']['user']['group']
  mode      '0700'
  recursive true
end
