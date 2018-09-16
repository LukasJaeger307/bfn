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

# We need rss and open-uri to find the name for an
# RSS feed
require 'rss'
require 'open-uri'

class FeedinfoEntry
	# Name and URL of the feed	
	attr :name
	attr :url

	# Date of last access
	attr :date, true

	def initialize(url)
		rss = open(url)
		feed = RSS::Parser.parse(rss)
		@name = feed.channel.title
		@url = url
		@date = Time.at(0)
	end

	#def initialize(name, url)
#		@name = name
#		@url = url
#		@date = Time.at(0)
#	end

end
