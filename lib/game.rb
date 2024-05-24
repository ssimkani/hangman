# frozen_string_literal: true

require 'yaml'
require_relative 'hangman'

# the Game class initializes a new hangman class and contains methods for
# loading the saved games, looping multiple hangman games, and displaying a welcome screen.
class Game
  def initialize
    # a new instance of the hangman class
    @hangman = Hangman.new
  end

  def welcome_message
    # Displays a welcome message and prompts the user to choose to play a new game,
    # load a saved game, or exit the program.
    puts 'WELCOME TO HANGMAN'

    print 'Enter 1 to play, 2 to load a game, or 0 to exit:  '
    input = gets.chomp
    case input
    when '0'
      exit
    when '1'
      puts "To save your game, enter 2 when prompted to guess a letter.\n\n"
      play_game
    when '2'
      files = []
      puts "Enter the number of the saved game you would like to load:\n\n"
      Dir.open('saved_games') do |dir|
        dir.each_child { |file| files << file }
        if files.empty?
          puts 'No saved games found.'
          exit
        else
          files.sort.each { |f| puts f }
        end
      end
      load_game(gets.chomp)

    else
      exit
    end
  end

  def play_game
    # This method starts a new game of hangman by calling the play method on
    # the hangman class. After a game is finishes, it then prompts the user if they
    # would like to play another game.
    loop do
      @hangman.play
      puts "\n\nEnter 1 to play again or 0 to exit:"
      input = gets.chomp
      break unless input == '1'

      initialize
      @hangman.play
    end
  end

  def load_game(num)
    # Loads the chosen yaml file from the saved_games directory based on the save number.
    File.open("saved_games/save_#{num}.yml", 'r') do |file|
      yaml_string = file.read
      @hangman = YAML.safe_load(yaml_string, permitted_classes: [Hangman])
      play_game
    end
  end
end
