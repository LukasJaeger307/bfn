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

require_relative 'TextExtractionInformation'

class FeedinfoEntry
	# Name and URL of the feed	
	attr :name
	attr :url

	# Date of last access
	attr :date, true
	attr :articleTitle, true
	attr :sectionTitle, true
	attr :paragraph, true

	def initialize(url, articleTitle, sectionTitle, paragraph)
		rss = open(url)
		feed = RSS::Parser.parse(rss, do_validate=false)
		@name = feed.channel.title
		@url = url
		@date = Time.at(0)
		@articleTitle = articleTitle
			#TextExtractionInformation.new("//h1","h1")
		@sectionTitle = sectionTitle
			#TextExtractionInformation.new("//h2[@class!=\"hidden\"]", "h2")
		@paragraph =  paragraph
			#TextExtractionInformation.new("//p[@class=\"text small\"]", "p")	
	end

	def to_s
		"#@name : #@url"
	end
end
