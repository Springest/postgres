#
# Cookbook Name:: postgresql
# Library:: helpers
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

module Postgresql
  module Helpers

    # delete all template attributes chef knows from all_attr
    # and return them in a seperate hash
    def extract_template_attributes(all_attr)
      # all template attributes chef knows
      t_attr = [ :name, :action, :backup, :cookbook, :path, :source,
                 :group, :mode, :inherits, :owner, :variables, :local ]
      o_attr = {}
      t_attr.each { |attr| o_attr[attr] = all_attr.delete(attr) if all_attr[attr] }
      o_attr
    end

    # merge d (defaults) with new hash (n)
    def merge_settings(d, n)
      r = d.to_hash
      n.each { |k, v| r[k.to_s] = v }
      r
    end

  end
end
