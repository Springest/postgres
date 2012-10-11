#
# Cookbook Name:: postgresql
# Definition:: pg_recovery
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

class Chef::Recipe
  include Postgresql::Helpers
end


define :pg_recovery, :action => :create, :cookbook => 'postgresql', :source => 'recovery.conf.erb' do
  include_recipe 'postgresql::install_server'

  # remove attributes that are not postgres configuration
  template_attr = extract_template_attributes(params)

  # fill in the nodes defaults if not given
  template_attr[:path]  ||= "#{node['postgresql']['data_dir']}/recovery.conf"
  template_attr[:owner] ||= node['postgresql']['db_user']
  template_attr[:group] ||= node['postgresql']['db_group']
  template_attr[:mode]  ||= '0644'

  # merge default settings with the ones given in additional parameters
  # (recovery.conf is empty by default, but anyways)
  recovery_conf = merge_settings(node['postgresql']['recovery.conf'], params)

  # check if this node is a postgres slave
  is_slave = File.exists? template_attr[:path]

  # use .done as file extension, if this node is a postgres master
  template_attr[:path].sub!(/\.[^\.]+$/, '.done') unless is_slave

  template template_attr[:name] do
    template_attr.each { |k, v| send(k, v) }
    notifies  :reload, resources(:service => 'postgresql') if is_slave
    variables :config => recovery_conf unless template_attr[:variables]
  end
end
