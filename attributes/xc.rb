#
# Cookbook Name:: postgres
# Attributes:: xc
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

default['postgres']['xc']['enabled'] = false
default['postgres']['xc']['version'] = '1.0.2'
default['postgres']['xc']['url'] = "http://garr.dl.sourceforge.net/project/postgres-xc/Version_1.0/pgxc-v#{node['postgres']['xc']['version']}.tar.gz"

default['postgres']['xc']['git']['repo'] = 'git://github.com/postgres-xc/postgres-xc.git'
default['postgres']['xc']['git']['branch'] = 'master'

default['postgres']['xc']['postgis']['version'] = '2.0.2'
default['postgres']['xc']['postgis']['patch'] = 'http://www.stormdb.com/sites/default/files/downloads/postgis_xc.patch'

default['postgres']['xc']['prefix'] = '/opt/postgres-xc'
default['postgres']['xc']['data_dir'] = node['postgres']['user']['home']
