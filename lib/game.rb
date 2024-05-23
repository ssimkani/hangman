# frozen_string_literal: true

require 'yaml'
require_relative 'hangman'

class Game
  def initialize
    @hangman = Hangman.new
  end

  def welcome_message
    puts 'WELCOME TO HANGMAN'
    begin
      print 'Enter 1 to play, 2 to load a game, or 0 to exit:  '
      input = gets.chomp
      case input
      when '0'
        exit
      when '1'
        puts "To save your game, enter 2 when prompted to guess a letter.\n\n"
        play_game
      when '2'
        begin
          print 'Enter the number of the saved game you would like to load:  '
          load_game(gets.chomp)
        rescue StandardError
          puts 'No saved game with that number. Please try again.'
          retry
        end
      else
        raise StandardError
      end
    rescue StandardError
      puts 'Please enter 1, 2, or 0.'
      retry
    end
  end

  def play_game
    loop do
      @hangman.play
      print 'Enter 1 to play again or 0 to exit:  '
      input = gets.chomp
      break unless input == '1'
    end
  end

  def load_game(num)
    File.open("saved_games/save_#{num}.yml", 'r') do |file|
      yaml_string = file.read
      object = YAML.safe_load(yaml_string)
      object.play
    end
  end
end

Game.new.welcome_message
