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

# Requires FeedCreator to create feeds
require_relative 'FeedCreator'

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
begin
	feedinfo = YAML.load(File.read(FEEDINFO_FILE))
rescue
	puts("Feedinfo file was damaged. Aborting")
	exit(1)
end

# Checking for an empty file
if feedinfo == false
	feedinfo = Feedinfo.new
end

# Sets whether or not all entries of a feed are shown
showAll = false

# Sets the briefing mode
briefing = false

# Function that makes the user select a feed interactively
def selectFeed(feedinfo)
	counter = 0
	entryArray = Array.new
	
	# Prints a list of all feeds
	feedinfo.feedinfo.each do |entry|
		puts (counter.to_s + " : " + entry.to_s)
		entryArray.append(entry)
		counter = counter + 1
	end
	
	# Gets the feed
	selection = gets.chomp.to_i
	if selection >= entryArray.size or selection < 0
		# No feed found, returning nil
		return nil
	else
		entryArray.at(selection)
	end
end

# Stores the feedinfo file in the home folder
def storeFeedinfo(feedinfo)
	# Serializing and storing feedinfo before end
	File.open(FEEDINFO_FILE, "w") do |file|
		file.puts(feedinfo.to_yaml)
	end
end

# Parsing command line options
OptionParser.new do |parser|
	parser.banner = "Usage: bfn.rb [options]"

	# Creating a new source interactively
	parser.on("-c", "--create",
						"Creates a new source in interactive mode") do
		feedinfo.addEntry(FeedCreator.new.create())
		storeFeedinfo(feedinfo)
		exit(0)
	end
	
	# Removing an URL from feedinfo
	parser.on("-r", "--remove",
					 "Removes an RSS-feed you may select from the list") do
		puts "Insert the number of the source you wish to remove:"
		selection = selectFeed(feedinfo)
		if selection == nil
			puts "You can't select that number, moron!"
			exit(1)
		else
			feedinfo.deleteEntry(selection)
		end
		storeFeedinfo(feedinfo)
		exit(0)
	end
	
	# Exporting a news feed
	parser.on("-e", "--export",
						"Exports a news source") do
		puts "Insert the number of the source you wish to export:"
		selection = selectFeed(feedinfo)
		if selection == nil
			puts "You can't select that number, moron!"
			exit(1)
		else
			puts "Give me a feed name"
			feedname = gets().chomp!
			filename = feedname + ".yaml"
			File.open(filename, "w") do |file|
				file.puts(selection.to_yaml)
			end
		end
		exit(0)
	end

	# Importing a news feed
	parser.on("-i", "--import FILENAME",
					"Imports a news feed") do |filename|
		if not File.exist?(filename)
			puts("Could not find file")
			exit(1)
		end
		begin
			feed = YAML.load(File.read(filename))
			feedinfo.addEntry(feed)
		rescue
			puts("Could not serialize file")
		end
		storeFeedinfo(feedinfo)
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

	# Listing all news in all feeds
	parser.on("-a", "--all",
						"Shows all RSS entries") do
		showAll = true
	end

	# Briefing mode opens the news with less
	parser.on("-b", "--briefing",
						"Briefing mode: Opens news.txt with Unix' less") do
		briefing = true
	end
	parser

end.parse!

newsItems = Hash.new

# Getting the news
feedinfo.feedinfo.each do |entry|
	open(entry.url) do |rss|
		feed = RSS::Parser.parse(rss, do_validate=false)
		puts "Title: #{feed.channel.title}"
		feed.items.select{|x| showAll || (x.date > entry.date)}.each do |x|
			puts "#{x.title}"
			userWillRead = gets().chomp
			if userWillRead == "y"
				newsItems[x] = entry
			end
		end
	end
	entry.date = Time.now
end

# Printing them
File.open("news.txt", "w") do |file|
	newsItems.each do |item, feedinfo|
		loader = WebpageLoader.new(item.link)
		loader.load(feedinfo).each do |line|
			file.write(line)
		end
	end
end

# If briefing mode is active, open news.txt with less
if briefing == true
	system("less news.txt")
end

# Storing the feedinfo before the program ends
storeFeedinfo(feedinfo)
