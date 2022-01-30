#!/usr/bin/env ruby

require 'colorize'
require './input_functions.rb'

#? prints colored heading on the terminal
def print_heading()
    puts "\e[H\e[2J"
    puts " "
    puts add_space("(ง ื▿ ื)ว TEXT MUSIC PLAYER▁ ▂ ▃ ▄", "center").colorize(:color => :green, :background => :black)
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
      # ask to select for album
      sleep(1)
      main()
  end
end

main()