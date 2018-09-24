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

# Requires Optparse for command line arguments
require 'optparse'

# Requires Feedinfo for a model for feedinfo
require_relative 'Feedinfo' 

# Requires Webpage loader
require_relative 'WebpageLoader'

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
feedinfo = YAML.load(File.read(FEEDINFO_FILE))

# Checking for an empty file
if feedinfo == false
	feedinfo = Feedinfo.new
end

showAll = false

# Parsing command line options
OptionParser.new do |parser|
	#parser.banner("Usage: bfn.rb --add URL\n
	#							bfn.rb --remove \n
#								bfn.rb --list \n
#								bfn.rb ")

	# Adding a new URL to the feedinfo
	parser.on("-a", "--add URL",
					"Adds an RSS-feed with URL to the list") do |url|
		feedinfo.addEntry(FeedinfoEntry.new(url))
		exit(0)
	end
	
	# Removing an URL from feedinfo
	parser.on("-r", "--remove",
					 "Removes an RSS-feed you may select from the list") do
		puts "Insert the number of the source you wish to remove:"
		counter = 0
		entryArray = Array.new
		feedinfo.feedinfo.each do |entry|
			puts (counter.to_s + " : " + entry.to_s)
			entryArray.append(entry)
			counter = counter + 1
		end
		selection = gets.chomp.to_i
		if selection >= entryArray.size or selection < 0
			puts "You can't select that number, moron!"
			exit(1)
		else
			feedinfo.deleteEntry(entryArray.at(selection))
		end
		exit(0)
	end

	# Listing all entries in feedinfo
	parser.on("-l", "--list",
						"Lists all news sources") do
		feedinfo.feedinfo.each do |x|
			puts x.to_s
		end
		exit(0)
	end

	parser.on("-a", "--all",
						"Shows all RSS entries") do
		showAll = true
	end
end.parse!

newsItems = Set.new

# Getting the news
feedinfo.feedinfo.each do |entry|
	open(entry.url) do |rss|
		feed = RSS::Parser.parse(rss)
		puts "Title: #{feed.channel.title}"
		feed.items.select{|x| showAll || (x.date > entry.date)}.each do |x|
			puts "#{x.title}"
			userWillRead = gets().chomp
			if userWillRead == "y"
				newsItems.add(x)
			end
		end
	end
	entry.date = Time.now
end

# Printing them
File.open("bfn_news.txt", "w") do |file|
	newsItems.each do |item|
		loader = WebpageLoader.new(item.link)
		loader.load().each do |line|
			file.write(line)
		end
	end
end
# Serializing and storing feedinfo before end
File.open(FEEDINFO_FILE, "w") do |file|
	file.puts(feedinfo.to_yaml)
end
