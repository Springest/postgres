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
include_recipe 'postgresql::install_server'

pg_conf 'postgresql.conf'
pg_hba 'pg_hba.conf' unless node['postgresql']['pg_hba.conf'].empty?
pg_ident 'pg_ident.conf' unless node['postgresql']['pg_ident.conf'].empty?
pg_recovery 'recovery.conf' unless node['postgresql']['recovery.conf'].empty?

# deploy certificates if configured
if node['postgresql']['certificate']

  # by default, use the certificate for this hostname
  if node['postgresql']['certificate'].to_s == 'true'
    pg_certificate node['hostname']

  # if specified, use certificate name
  else
    pg_certificate node['postgresql']['certificate']
  end
end
