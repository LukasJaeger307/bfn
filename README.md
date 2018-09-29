# BFN - Bullshit-Free News on your command line #

Getting tired of flashy animations, noisy audio streams and unnerving
advertisement when you just want to read the news and have a cup of
coffee? BFN is here for the rescue. If your favourite news webpages
feature an RSS feed (which they most probably do), BFN can scan for 
the latest news, ask you, whether or not you find the found articles
interesting, extract the texts from the webpages and print them on
the command line. That way, you get updated and not distracted.

BFN is written in the Ruby programming language. It should be
executable on Linux, Windows and MacOS alike. However since I am a
Linux afficionado, I have no other OS and did not test it on any
other platform. Feel free to do so.

## Installing ##
You need [nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html) installed.
Follow the tutorial or search your Linux distribution's repositories. Now open a terminal,
clone the repository and you're done installing.

## Using BFN ##
### Importing news feeds ###
In BFN news feeds are objects that store the URL of the RSS index and some xpath information
that is used to extract the text. These news feeds are stored as YAML-files. Examples can 
be found in the _feeds_ folder. In order to import these, execute BFN like this:

```sh
./bfn.rb -i feeds/tagesschau.de.yaml
```

If you know your way around xpath and webdesign, you can instead

### Create a news feed ###
BFN needs to find an article title, section titles and text paragraphs. In order to define a
new news feed, you need to open the source code of your news webpage, find the HTML-elements
that contain these text snippets and create xpath-expressions to search for them. If you have
done that, you execute BFN like this:

```sh
./bfn.rb -c
```

This opens the interactive news feed creation mode. You are first asked for the URL of the RSS
index. Then you have to provide the xpath string to find the article headline. tagesschau.de
for example provides article headlines in HTML-elements of type _\<h1\>_, therefore the xpath
search string is _//h1_ and the name is _h1_. You get asked about the xpath string and the name
of the section titles and the paragraphs as well. tagesschau.de has its section titles in elements
of type _\<h2\>_ where the class is not _hidden_. Therefore the xpath string is _//h2[@class!=hidden]_
and the name is _h2_. The paragraphs are stored in _\<p\>_ elements of the _text small_ class. The
resulting xpath string is _//p[@class="text small"]_ and the name is _p_.

### Export a news feed ###
You created your own news feed and want to share? Terrific! Just call

```sh
./bfn.rb -e
```

You are asked then which feed you want to export, you get to select a filename (which will be expanded by
the _.yaml_ file ending so don't add one yourself) and the feed will be serialized so that you and others
can import it as described above.

### Read the news ###
#### Default mode ####
Call

```sh
./bfn.rb 
```

and BFN will check your RSS feeds for update, ask you, what news you want to read, extract the text from
all of them and write it to _news.txt_.

#### Briefing mode (Unix only) ####
The briefing mode works only on systems that can execute Unix' _less_-command. If you have one of these
systems, call

```sh
./bfn.rb -b
```
The briefing mode acts like the default mode except that it automatically opens _news.txt_ with Unix' _less_.

#### All entries ####
By default, BFN tracks the time you accessed your news feeds last and only displays you news that were published
after that point of time. If you want all the news in the feed, call

```sh
./bfn.rb -a
```

This can be combined with the briefing mode.
