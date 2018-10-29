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

class RSSFilter
	
	attr :filterList
	
	def initialize(path)
		@filterList = []
		File.readlines(path).each do |line|
			filterList.push(line)
		end
	end

	def filter(rssFeed)
		filteredItems = []
		rssFeed.items.each do |item|
			found = false
			@filterList.each do |listEntry|
				trimmedListEntry = listEntry.strip
				if item.title.include?(trimmedListEntry) or
						item.description.include?(trimmedListEntry)
					found = true
				end
			end
			if not found
				filteredItems.push(item)
			end
		end
		filteredItems
	end
end
