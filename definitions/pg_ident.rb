#
# Cookbook Name:: postgresql
# Definition:: pg_ident
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


define :pg_ident, :action => :create, :cookbook => 'postgresql', :source => 'pg_ident.conf.erb' do
  include_recipe 'postgresql::install_server'

  # remove attributes that are not postgres configuration
  template_attr = extract_template_attributes(params)

  # fill in the nodes defaults if not given
  template_attr[:mode]  ||= '0640'
  template_attr[:path]  ||= "#{node['postgresql']['conf_dir']}/pg_ident.conf"
  template_attr[:owner] ||= node['postgresql']['db_user']
  template_attr[:group] ||= node['postgresql']['db_group']

  # add default rule unless specified
  params[:rules] ||= node['postgresql']['pg_ident.conf']

  template 'pg_ident.conf' do
    template_attr.each { |k, v| send(k, v) }

    variables :config => Array(params[:rules])
    notifies  :reload, resources(:service => 'postgresql')
  end
end
