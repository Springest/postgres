#
# Cookbook Name:: postgres
# Attributes:: postgis
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

include_attribute 'postgres::default'

default['postgis']['version'] = '2.0.2'
default['postgis']['url'] = "http://download.osgeo.org/postgis/source/postgis-#{node['postgis']['version']}.tar.gz"
default['postgis']['pg_config'] = '/usr/bin/pg_config'

default['postgis']['svn']['repo'] = 'http://svn.osgeo.org/postgis/trunk'

case platform
when 'ubuntu', 'debian'
  default['postgis']['packages'] = [ 'postgis', "postgresql-#{node['postgres']['version']}-postgis" ]
else
  default['postgis']['packages'] = 'postgis'
end
