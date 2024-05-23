require_relative 'hangman'

class Game
  def play_game
    Hangman.new.play
  end
end
