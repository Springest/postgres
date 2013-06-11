#
# Cookbook Name:: postgres
# Recipe:: svn-install-postgis
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


# install required packages
case node['platform_family']
when 'debian'
  pkgs = %w[curl build-essential libpq-dev libxml2-dev libproj-dev libgeos-dev libgdal1-dev]
  pkgs << "postgresql-server-dev-#{node['postgres']['version']}"

when 'rhel'
  pkgs = %w[curl make gcc automake postgresql-devel libxml2-devel proj-devel geos-devel gdal-devel]
end

pkgs.each { |pkg| package pkg }


def install_postgis
  tmpdir = %x[mktemp -d].chomp

  subversion tmpdir do
    repository node['postgis']['svn']['repo']
  end

  execute 'creating ./configure' do
    cwd tmpdir
    command "./autogen.sh"
    not_if "test -f #{tmpdir}/configure"
  end

  execute 'configuring postgis.svn' do
    cwd tmpdir
    command "./configure --with-pgconfig=#{node['postgis']['pg_config']}"
  end

  execute 'compiling postgis.svn' do
    cwd tmpdir
    command 'make'
  end

  execute 'installing postgis.svn' do
    cwd tmpdir
    command 'make install'
  end

  directory tmpdir do
    recursive true
    action    :delete
  end
end

# consider postgis installed if postgis-x.x exists in the contrib folder
install_postgis unless ::File.directory? "#{node['postgres']['contrib_dir']}/postgis-#{node['postgis']['version'].slice(/^\d+\.\d+/)}"
