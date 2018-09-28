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

require_relative 'TextExtractionInformation'
require_relative 'FeedinfoEntry'

class FeedCreator
	
	def create
		
		puts ("Enter the URL:")
		url = gets.chomp!
		if url == "q"
			exit(0)
		end

		puts ("Enter the xpath string to fetch the article title:")
		xpath = gets.chomp!
		if xpath == "q"
				exit (0)
		end

		puts ("Enter the name of the article title element:")
		name = gets.chomp!
		if name == "q"
				exit (0)
		end

		articleTitle = TextExtractionInformation.new(xpath, name)

		puts ("Enter the xpath string to fetch the section titles:")
		xpath = gets.chomp!
		if xpath == "q"
				exit (0)
		end

		puts ("Enter the name of the section title elements:")
		name = gets.chomp!
		if name == "q"
				exit (0)
		end

		sectionTitle = TextExtractionInformation.new(xpath, name)
		
		puts ("Enter the xpath string to fetch the paragraphs:")
		xpath = gets.chomp!
		if xpath == "q"
				exit (0)
		end

		puts ("Enter the name of the paragraphs:")
		name = gets.chomp!
		if name == "q"
				exit (0)
		end

		paragraph = TextExtractionInformation.new(xpath, name)

		FeedinfoEntry.new(url, articleTitle, sectionTitle, paragraph)
	end
end
