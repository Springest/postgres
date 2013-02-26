#
# Cookbook Name:: postgresql
# Provider:: install_xc
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

  # initscript
  # logrotate

  # xc-controller
  # xc-data
  # xc-gdm
  # xc-postgis


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
end
