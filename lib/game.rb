# frozen_string_literal: true

require 'yaml'
require_relative 'hangman'

class Game
  def initialize
    @hangman = Hangman.new
  end

  def welcome_message
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
          files.each { |f| puts f }
        end
      end
      load_game(gets.chomp)

    else
      exit
    end
  end

  def play_game
    @hangman.play
  end

  def load_game(num)
    File.open("saved_games/save_#{num}.yml", 'r') do |file|
      yaml_string = file.read
      object = YAML.safe_load(yaml_string, permitted_classes: [Hangman])
      object.play
    end
  end
end

Game.new.welcome_message
