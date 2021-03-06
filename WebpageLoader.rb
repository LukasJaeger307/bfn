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

# Requires open-uri in order to download pages
require 'open-uri'
require 'nokogiri'
require_relative 'TextExtractor'

class WebpageLoader
	
	attr :url
	
	def initialize(url)
		@url = url
		@extractor = TextExtractor.new
	end

	def load(feedinfo)
		begin
			doc = Nokogiri::HTML(open(@url))
		rescue URI::InvalidURIError
			doc = Nokogiri::HTML(open(URI.escape(@url)))
		end
		@extractor.extract(doc, feedinfo)
	end

end
