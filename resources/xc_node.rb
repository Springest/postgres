#
# Cookbook Name:: postgres
# Resource:: xc_node
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

actions        :create
default_action :create

attribute :nodename,  :kind_of => String, :name_attribute => true
attribute :listen_addresses, :kind_of => String,  :default => '127.0.0.1'
attribute :port,             :kind_of => Integer, :default => 5432
attribute :pooler_port,      :kind_of => Integer, :default => nil
attribute :gtm_host,         :kind_of => String,  :default => '127.0.0.1'
attribute :gtm_port,         :kind_of => Integer, :default => 6666
attribute :max_connections,  :kind_of => Integer, :default => 100
attribute :shared_buffers,   :kind_of => String,  :default => '24MB'

attribute :cookbook,  :kind_of => String, :default => 'postgres'
attribute :source,    :kind_of => String, :default => 'xc/postgresql.conf.erb'
attribute :variables, :kind_of => Hash,   :default => {}
