#
# Cookbook Name:: postgres
# Resource:: xc_gtm
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

attribute :nodename,         :kind_of => String, :name_attribute => true
attribute :listen_addresses, :kind_of => String,  :default => '127.0.0.1'
attribute :port,             :kind_of => Integer, :default => 6666
attribute :startup,          :kind_of => String,  :default => 'ACT'
