#!/usr/bin/env ruby

require 'colorize'
require './input_functions.rb'

#?
def main()
  user_input = home_menu()
  case user_input
  when 1
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