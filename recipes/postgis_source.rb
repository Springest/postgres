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

# install required packages (ubuntu)
if node.platform == 'ubuntu'
  package 'wget'
  package 'build-essential'
  package "postgresql-server-dev-#{node['postgresql']['version']}"
  package 'libpq-dev'
  package 'libxml2-dev'
  package 'libproj-dev'
  package 'libgeos-dev'

  # gdal has a lot of dependencies (e.g. mysql-common)
  package 'libgdal1-dev'
end


script "download, compile and install postgis-#{node['postgis']['version']}" do
  interpreter 'bash'
  user 'root'
  cwd '/tmp'
  code <<-EOH
    rm -rf postgis-#{node['postgis']['version']}.tar.gz
    wget http://download.osgeo.org/postgis/source/postgis-#{node['postgis']['version']}.tar.gz
    tar xvzf postgis-#{node['postgis']['version']}.tar.gz
    cd postgis-#{node['postgis']['version']}
    ./configure
    make
    make install
    cd ..
    rm -rf postgis-#{node['postgis']['version']} postgis-#{node['postgis']['version']}.tar.gz
  EOH

  # consider postgis installed if postgis-x.x exists in the contrib folder
  not_if "test -d /usr/share/postgresql/#{node['postgresql']['version']}/contrib/postgis-#{node['postgis']['version'].slice(/^\d+\.\d+/)}"
end
