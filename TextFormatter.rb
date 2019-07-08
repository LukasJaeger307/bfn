# Copyright 2019, Lukas Jäger
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

class TextFormatter

  def initialize (linelength)
   @linelength = linelength
  end

  def format (textlines)
    formattedlines = Array.new
    buffer = textlines.shift

    while not buffer.empty?
      bufferlength = buffer.length
      if bufferlength < @linelength
        # Buffer is small enough, it gets appended to the formtatted lines
        formattedlines.append(buffer)
        buffer = ""
      elsif breakindex = buffer.index('\n', @linelength)
        # TODO: Do something about linebreaks
      else
        breakindex = buffer.rindex(' ', @linelength)
        if breakindex == nil or breakindex == 0
          # Could not find a blank, we just break at linelength
          breakindex = @linelength
        end
        formattedlines.append(buffer[0..breakindex].strip!)
        buffer = buffer[breakindex..bufferlength]
      end
      # Appends the next line to the buffer if any are left
      if not textlines.empty?
        buffer = buffer + textlines.shift
      end
    end

    formattedlines
  end

end
