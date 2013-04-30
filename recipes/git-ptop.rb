#
# Cookbook Name:: postgres
# Recipe:: git-ptop
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

package 'git-core'
package 'build-essential'
package 'libncurses5-dev'

# get rid of old ptop
package 'ptop' do
  action :purge
end

def install_pg_top
  tmpdir = %x[mktemp -d].chomp

  git tmpdir do
    repository node['postgres']['ptop']['git']['repo']
    revision   node['postgres']['ptop']['git']['branch']
    depth 1
  end

  execute 'running autogen.sh' do
    cwd tmpdir
    command './autogen.sh'
  end

  execute 'running configure' do
    cwd tmpdir
    command "./configure --prefix=#{node['postgres']['ptop']['prefix']}"
  end

  execute 'compiling postgres-xc' do
    cwd tmpdir
    command 'make && make install'
  end

  directory tmpdir do
    recursive true
    action    :delete
  end
end

install_pg_top unless ::File.exists? "#{node['postgres']['ptop']['prefix']}/bin/pg_top"
