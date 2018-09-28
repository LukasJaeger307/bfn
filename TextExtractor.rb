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

# Requires nokogiri for xpath based text extraction
require 'nokogiri'

class TextExtractor

	def extract (doc, feedinfo)
		xpathString = feedinfo.articleTitle.xpath + " | " +
			feedinfo.sectionTitle.xpath + " | " +
			feedinfo.paragraph.xpath

		paragraphs = doc.xpath(xpathString)
		text = Array.new
		paragraphs.each do |paragraph|
			if paragraph.name == feedinfo.articleTitle.name
				text.append("# ")
				paragraph.children.each do |child|
					strippedText = child.text.strip
					if not strippedText.empty?
						text.append(child.text.strip + " ")
					end
				end
				text.append("#\n\n")
			# Sub-headline found
			elsif paragraph.name == feedinfo.sectionTitle.name
				paragraph.children.each do |child|
					strippedText = child.text.strip
					if strippedText != nil
						text.append("## " + strippedText + " ##")
						text.append("\n\n")
					end
				end
			# Paragraph found
			elsif paragraph.name == feedinfo.paragraph.name
				paragraph.children.each do |child|
					strippedText = child.text.strip
					if not strippedText.empty?
						text.append(strippedText)
						text.append("\n\n")
					end
				end
			end
		end
		text.append("\n\n")
		text
	end
end

