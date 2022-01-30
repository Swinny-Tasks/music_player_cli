#!/usr/bin/env ruby

require 'colorize'
require './input_functions.rb'

class Album
    attr_accessor :title, :artist, :genre ,:tracks
    def initialize(title, artist, genre, tracks)
        @title = title
        @artist = artist
        @tracks = tracks
        @genre = genre
    end
end

class Track
    attr_accessor :title, :path
    def initialize(title, path)
        @title = title
        @path = path
    end
end

#? prints colored heading on the terminal
def print_heading()
    puts "\e[H\e[2J"
    puts " "
    puts add_space("(ง ื▿ ื)ว TEXT MUSIC PLAYER▁ ▂ ▃ ▄", "center").colorize(:color => :green, :background => :black)
end

#? takes in text and align as parameters. returns text with whitespace
def add_space(text, align)
    case align
    when "left"
        space_before = 2
        space_after = 58 - text.size()
    when "center"
        space_before = space_after = (60 - text.size())/2
        space_before += 1 if text.size() % 2 != 0
    when "columnL"
        space_before = 2
        space_after = 28 - text.size()
    when "columnR"
        space_after = 2
        space_before = 28 - text.size()
    end
    space_before.times {text = " " + text}
    space_after.times {text = text + " "}
    return text
end

#? asks user what option they choose from the list provided
def home_menu()
    print_heading()
    puts add_space("Main Menu", "left").colorize(:color => :black, :background => :green)
    puts add_space("1. Read in Albums", "left").colorize(:color => :white, :background => :light_green)
    puts add_space("2. Display Albums", "left").colorize(:color => :white, :background => :light_green)
    puts add_space("3. Select an Album to play", "left").colorize(:color => :white, :background => :light_green)
    puts add_space("4. Update an existing Album", "left").colorize(:color => :white, :background => :light_green)
    puts add_space("5. Exit the application", "left").colorize(:color => :white, :background => :light_green)
    return read_integer_in_range(">>>  ", 1, 5)
end

#?
def main()
  user_input = home_menu()
  case user_input
  when 1
    print_heading()
    # main function
  when 5
    # print goodbye
  else
    puts add_space("⚠️ please select an album ⚠️", "center").colorize(:color => :red, :background => :black)
    sleep(1)
    main()
  end
end

main()