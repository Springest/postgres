#
# Cookbook Name:: postgres
# Recipe:: dedicated_server
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

# converts plain kb value to "xxxxMB"
def kb2mb value
  "#{(value / 1024).to_i}MB"
end

system_mem = node['memory']['total'].to_i

# every connection uses up to work_mem memory, so make sure that even if
# max_connections is reached, there's still a bit left.
# total available memory / (2 * max_connections)
node.override['postgresql']['postgresql.conf']['work_mem'] = kb2mb(system_mem * 0.9 / node['postgresql']['postgresql.conf']['max_connections'])

# shared_buffers should be 0.2 - 0.3 of system ram
# unless ram is lower than 1gb, then less (32mb maybe)
node.override['postgresql']['postgresql.conf']['shared_buffers'] = kb2mb(system_mem * 0.25)

# maintenance_work_mem, should be a lot higher than work_mem
# recommended value: 50mb for each 1gb of system ram
node.override['postgresql']['postgresql.conf']['maintenance_work_mem'] = kb2mb(system_mem / 1024 * 50)

# effective_cache_size between 0.6 and 0.8 of system ram
node.override['postgresql']['postgresql.conf']['effective_cache_size'] = kb2mb(system_mem * 0.75)

# wal_buffers should be between 2-16mb
node.override['postgresql']['postgresql.conf']['wal_buffers'] = '12MB'



# get pagesize
pagesize = %x[getconf PAGESIZE].to_i || 4096

# use half of system memory for shmmax
shmmax = system_mem * 1024 / 2
shmall = shmmax / pagesize

set_sysctl '30-postgresql-shm' do
  sysctls 'vm.overcommit_memory' => 2,
          'kernel.shmmax' => shmmax,
          'kernel.shmall' => shmall
end


include_recipe 'postgresql::default_server'
