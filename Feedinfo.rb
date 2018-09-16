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

require_relative 'FeedinfoEntry'

class Feedinfo
	
	def initialize()
		@feedinfo = Set.new
	end

	def addEntry(entry)

		# Searching for entries with the same URL
		sameURLEntries = @feedinfo.select do |selectEntry|
			selectEntry.url == entry.url
		end
		if sameURLEntries.size == 0
			@feedinfo.add(entry)
			return true
		else
			return false
		end
	end
end
