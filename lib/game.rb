require 'yaml'
require_relative 'hangman'

class Game
  def initialize
    @object = Hangman.new
  end

  def play_game
    loop do
      @object.play
      puts 'Enter 1 to play again or 0 to exit'
      input = gets.chomp
      break unless input == '1'
    end
  end

  def to_yaml(object, counter)
    yaml_string = object.to_yaml
    File.open("saved_games/save_#{counter}.yml", 'w') do |file|
      file.write(yaml_string)
    end
  end

  def load_game(counter)
    File.open("saved_games/save_#{counter}.yml", 'r') do |file|
      yaml_string = file.read
      object = YAML.safe_load(yaml_string)
      object
    end
  end
end

Game.new.play
