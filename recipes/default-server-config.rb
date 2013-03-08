#
# Cookbook Name:: postgres
# Recipe:: default-server-config
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

postgresql_config 'postgresql.conf'
postgresql_hba 'pg_hba.conf'

# deploy certificates if configured
if node['postgres']['certificate']

  # by default, use the certificate for this hostname
  if node['postgres']['certificate'].to_s == 'true'
    postgresql_certificate node['hostname']

  # if specified, use certificate name
  else
    postgresql_certificate node['postgres']['certificate']
  end
end
