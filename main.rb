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

#? adds pause to the program until the user interacts with ENTER key
def enter_to_continue
    puts add_space("Press ENTER...", "left").colorize(:color => :blue)
    gets()
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

#? returns confirmed file_path entered by the user
def read_albums_path()
    puts add_space("Enter Album", "left").colorize(:color => :black, :background => :red)
    puts add_space("Enter the filename of the music library", "left").colorize(:color => :white, :background => :light_red)
    file_path = read_string(">>>  ")
    loop do
        if File.exists?(file_path)
            puts add_space("Music Library Loaded.", "left").colorize(:color => :green)
            enter_to_continue()
            return file_path
        else
            puts add_space("⚠️ FILE NOT FOUND ⚠️", "center").colorize(:color => :red, :background => :black)
            file_path = read_string(">>>  ")
        end
    end
end

#? returns a single album from the file in form of a class token
def album_data(file)
    album_first_name = file.readline().chomp()
    artist_first_name = file.readline().chomp()
    genre = file.readline().chomp()
    tracks = Array.new()
    track_number = file.readline().to_i()
    track_number.times{
        single_track_name = file.readline().chomp()
        single_track_location = file.readline().chomp()
        tracks.push(Track.new(single_track_name, single_track_location))
    }
    album = Album.new(album_first_name, artist_first_name, genre, tracks)
    return album
end

#? returns array of all albums there in the file
def read_album_list(path)
    album_list = Array.new()
    File.open(path, "r") do |file|
        number_of_albums = file.readline.to_i()
        number_of_albums.times{
            single_album = album_data(file)
            album_list.push(single_album)
        }
    end
    return album_list
end

#? asks user for display options (album or genre). used in menu 2
def display_albums_menu()
    puts add_space("Display Albums", "left").colorize(:color => :black, :background => :red)
    puts add_space("1. Display All", "left").colorize(:color => :white, :background => :light_red)
    puts add_space("2. Display Genre", "left").colorize(:color => :white, :background => :light_red)
    option = read_integer_in_range(">>>  ", 1, 2)
end

#? prints details of the given album
def display_album_details(album, index)
    #* added 3-spaces after album.title to make it at exact center. (to balance out index number)
    puts add_space((index.to_s + ". " + album.title + "   "), "center").colorize(:color => :black, :background => :magenta)
    print add_space(album.artist, "columnL").colorize(:color => :black, :background => :magenta)
    puts add_space(album.genre, "columnR").colorize(:color => :black, :background => :magenta)
    for track in album.tracks
        print add_space(track.title, "columnL").colorize(:color => :white, :background => :light_magenta)
        puts add_space(track.path, "columnR").colorize(:color => :light_black, :background => :light_magenta)
    end
end

#? displays all albums in the genre selected by the user
def display_genre_list(album_list)
    print_heading()
    puts add_space("Genre List", "left").colorize(:color => :black, :background => :cyan)
    unique_genre = Array.new
    for i in 0...album_list.size()
        unique_genre.push(album_list[i].genre) if not unique_genre.include?(album_list[i].genre)
    end
    for i in 0...unique_genre.size()
        #* added 1 to avoid giving 0 as an option
        puts add_space("#{(i+1)}. #{unique_genre[i]}", "left").colorize(:color => :white, :background => :light_cyan)
    end
    genre_to_display = read_integer_in_range("Select Genre: ", 1, unique_genre.size()) - 1
    
    print_heading()
    for i in 0...album_list.size()
        (display_album_details(album_list[i], i+1); puts "") if album_list[i].genre == unique_genre[genre_to_display]
    end
end

#? menu for main option 3
def display_play_options()
    print_heading()
    puts add_space("Play ..(•.•)", "left").colorize(:color => :black, :background => :red)
    puts add_space("1. Play by ID", "left").colorize(:color => :white, :background => :light_red)
    puts add_space("2. Search for tracks", "left").colorize(:color => :white, :background => :light_red)
    play_option = read_integer_in_range(">>> ", 1, 2)
    return play_option
end

#? returns list of all songs
def get_song_index(album_list)
    song_indexes = Array.new()
    for album in album_list
        for track in album.tracks
            song_indexes.push(track)
            print add_space("#{song_indexes.size()}. #{track.title}", "columnL").colorize(:color => :white, :background => :light_blue)
            puts add_space(album.title, "columnR").colorize(:color => :light_white, :background => :light_blue)
        end
    end
    return song_indexes
end

#? displays the list of all songs and returns the selected track by the user
def display_song_list(album_list)
    puts add_space("Select song ID", "left").colorize(:color => :black, :background => :blue)
    song_indexes = get_song_index(album_list)
    selected_song = read_integer_in_range(">>> ", 1, song_indexes.size()) - 1
    song_to_play = song_indexes[selected_song].path
    puts ("Playing track #{selected_song + 1}- #{song_indexes[selected_song].title}").colorize(:color => :yellow)
    return song_to_play
end

#? pauses for 2 seconds instead of actually playing the song.
#? for demo 
#todo change this at the end
def play(song_path)
    sleep(2)
end

#? searches for song by title. plays it if found, shows error if not found
def search_for_song(album_list)
    def local_search(song_indexes)
        user_search = read_string("Query: ")
        scanned = 0
        for i in 0...song_indexes.size()
            if song_indexes[i].title.downcase() == user_search.downcase()
                play(song_indexes[i].path)
                puts ("Playing track #{i + 1}- #{song_indexes[i].title}").colorize(:color => :yellow)
            else
                scanned += 1
            end
        end
        if scanned == song_indexes.size()
            puts add_space("⚠️ song not found ⚠️", "center").colorize(:color => :red, :background => :black)
            local_search(song_indexes)
        end
    end
    puts add_space("Search for Song", "left").colorize(:color => :black, :background => :blue)
    song_indexes = get_song_index(album_list)
    local_search(song_indexes)
end

#? returns what album the user wants to edit
def display_update_menu(album_list)
    print_heading()
    puts add_space("Edit Album", "left").colorize(:color => :black, :background => :red)
    puts add_space("Enter Album ID you want to edit", "left").colorize(:color => :white, :background => :light_red)
    puts ""
    for i in 0...album_list.size()
        print add_space("#{i+1}. #{album_list[i].title}", "columnL").colorize(:color => :black, :background => :yellow)
        puts add_space(album_list[i].genre, "columnR").colorize(:color => :light_black, :background => :yellow)
    end
    album_to_edit = read_integer_in_range(">>> ", 1, album_list.size()) - 1
    return album_to_edit
end

#? returns what album detail the user want to edit
def display_update_options()
    print_heading()
    puts add_space("Edit Options", "left").colorize(:color => :black, :background => :red)
    puts add_space("1. Album Title", "left").colorize(:color => :white, :background => :light_red)
    puts add_space("2. Genre", "left").colorize(:color => :white, :background => :light_red)
    puts add_space("3. Track information", "left").colorize(:color => :white, :background => :light_red)
    info_to_edit = read_integer_in_range(">>> ", 1, 3)
    return info_to_edit
end

#? edits the album element reqested by the user
def update_album(album_list, album_to_edit, property)
    puts add_space("Editing Album", "left").colorize(:color => :black, :background => :yellow)
    puts add_space("Enter new #{property} for #{album_list[album_to_edit].title}", "left").colorize(:color => :light_black, :background => :light_yellow)
    new_info = read_string(">>> ")
    return new_info
end

#? edit track title requested by the user
def update_tracks(album_list, album_to_edit, path)
    puts add_space("Select track to edit", "left").colorize(:color => :black, :background => :cyan)
    index = 0
    for track in album_list[album_to_edit].tracks
        index += 1
        puts add_space("#{index}. #{track.title}", "left").colorize(:color => :white, :background => :light_cyan)
    end
    track_to_edit = read_integer_in_range(">>> ", 1, index) -1
    new_title = read_string("enter new name:")
    #puts album_list[album_to_edit].tracks[track_to_edit].title
    updated_file = File.read(path).sub(album_list[album_to_edit].tracks[track_to_edit].title, new_title.chomp())
    return updated_file
end

#?
def main()
  user_input = home_menu()
  case user_input
  when 1
    print_heading()
    path = read_albums_path()
    album_list = read_album_list(path)
  when 5
    # print goodbye
  else
    puts add_space("⚠️ please select an album ⚠️", "center").colorize(:color => :red, :background => :black)
    sleep(1)
    main()
  end
end

main()