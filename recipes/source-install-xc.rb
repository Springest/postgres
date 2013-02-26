#
# Cookbook Name:: postgres
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
    command "curl #{node['postgres']['xc']['url']} |tar -zxf -"
  end

  execute 'patching postgres-xc' do
    cwd "#{tmpdir}/pgxc-v#{node['postgres']['xc']['version']}"
    command "curl #{node['postgres']['xc']['postgis']['patch']} |patch -p1"
    only_if { node['postgres']['xc']['postgis']['patch'] }
  end

  execute 'running configure' do
    cwd "#{tmpdir}/pgxc-v#{node['postgres']['xc']['version']}"
    command "./configure --with-openssl --prefix=#{node['postgres']['xc']['prefix']}"
  end

  execute 'compiling postgres-xc' do
    cwd "#{tmpdir}/pgxc-v#{node['postgres']['xc']['version']}"
    command 'make && make install'
  end

  execute 'compiling postgres-xc (contrib)' do
    cwd "#{tmpdir}/pgxc-v#{node['postgres']['xc']['version']}/contrib"
    command 'make && make install'
  end

  directory tmpdir do
    action :delete
    recursive true
  end
end

install_postgres_xc unless ::File.directory?(node['postgres']['xc']['prefix'])

# create symlinks to /usr/local/bin
%w(
  clusterdb createdb createlang createuser dropdb droplang dropuser
  ecpg gtm gtm_ctl gtm_proxy initdb initgtm makesgml oid2name
  pg_archivecleanup pg_basebackup pgbench pg_config pg_controldata
  pg_ctl pg_dump pg_dumpall pg_resetxlog pg_restore pg_standby pg_test_fsync
  pg_upgrade pgxc_clean postgres postmaster psql reindexdb vacuumdb vacuumlo
).each do |bin|
  link "/usr/local/bin/#{bin}" do
    to "#{node['postgres']['xc']['prefix']}/bin/#{bin}"
  end
end

node.set['postgis']['pg_config'] = "#{node['postgres']['xc']['prefix']}/bin/pg_config"
node.set['postgres']['contrib_dir'] = "#{node['postgres']['xc']['prefix']}/share/contrib"
node.set['postgres']['xc']['enabled'] = true


# # deploy init script
# template '/etc/init.d/postgres-xc' do
#   cookbook 'postgres'
#   source   'postgres-xc.init.erb'
#   mode     '0755'
#   # variables :logfile =>
#   #           :conf_dir =>
# end

# install logrotate rules
# logrotate_app 'postgres-xc' do
#   path '/var/log/postgres-xc/*.log'
#   options [ 'missingok', 'notifempty', 'copytruncate', 'compress' ]
#   frequency 'daily'
#   rotate 7
# end


# create user/group
group node['postgres']['user']['group'] do
  system true
end

user node['postgres']['user']['name'] do
  gid    node['postgres']['user']['group']
  home   node['postgres']['user']['home']
  system true
end

directory node['postgres']['user']['home'] do
  owner     node['postgres']['user']['name']
  group     node['postgres']['user']['group']
  mode      '0755'
end
