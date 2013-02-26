#
# Cookbook Name:: postgres
# Recipe:: postgis_source
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

# install required packages (ubuntu)
if node.platform == 'ubuntu'
  package 'wget'
  package 'build-essential'
  package 'libpq-dev'
  package 'libxml2-dev'
  package 'libproj-dev'
  package 'libgeos-dev'

  # gdal has a lot of dependencies (e.g. mysql-common)
  package 'libgdal1-dev'

  # don't install server-dev package when using postgres-xc
  package "postgresql-server-dev-#{node['postgresql']['version']}" unless node['postgresql']['xc']['enabled']
end

def install_postgis
  tmpdir = %x[mktemp -d].chomp

  execute "downloading postgis-#{node['postgis']['version']}" do
    cwd tmpdir
    command "curl #{node['postgis']['url']} |tar -zxf -"
  end

  execute "configuring postgis-#{node['postgis']['version']}" do
    cwd "#{tmpdir}/postgis-#{node['postgis']['version']}"
    command "./configure --with-pgconfig=#{node['postgis']['pg_config']}"
  end

  execute "compiling postgis-#{node['postgis']['version']}" do
    cwd "#{tmpdir}/postgis-#{node['postgis']['version']}"
    command 'make'
  end

  execute "installing postgis-#{node['postgis']['version']}" do
    cwd "#{tmpdir}/postgis-#{node['postgis']['version']}"
    command 'make install'
  end

  directory tmpdir do
    action :delete
    recursive true
  end
end

# consider postgis installed if postgis-x.x exists in the contrib folder
install_postgis unless ::File.directory? "#{node['postgresql']['contrib_dir']}/postgis-#{node['postgis']['version'].slice(/^\d+\.\d+/)}"
