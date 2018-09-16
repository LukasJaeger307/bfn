#!/usr/bin/ruby

# Copyright 2018, Lukas Jäger
#
# This file is part of bfn.
#
# bfn is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# bfn is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with bfn.  If not, see <http://www.gnu.org/licenses/>.

# Requires YAML for serializing
require 'yaml'

SETTINGS_FOLDER = Dir.home() + "/.bfn"
FEEDINFO_FILE = SETTINGS_FOLDER + "/feedinfo.yaml"

# Checking, whether or not we have a settings folder.
# If we don't have one, we create one.
if not File.exist?(SETTINGS_FOLDER)
	Dir.mkdir(SETTINGS_FOLDER)
end

# Checking, whether or not the feedinfo-file is available.
# If it is not, it is created.

if not File.exist?(FEEDINFO_FILE)
	File.open(FEEDINFO_FILE, "w"){}
end

# De-Serializing feedinfo from the feedinfo-file
feedInfo = YAML.load(File.read(FEEDINFO_FILE))
