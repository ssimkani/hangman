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

  def to_yaml(object)
    yaml_string = object.to_yaml
    File.open('../save.yml', 'w') do |file|
      file.write(yaml_string)
    end
  end
end

Game.new.play_game
