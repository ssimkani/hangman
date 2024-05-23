require_relative 'hangman'

class Game
  def play_game
    loop do
      Hangman.new.play
      puts 'Enter 1 to play again or 0 to exit'
      input = gets.chomp
      break unless input == '1'
    end
  end
end

Game.new.play_game
