# frozen_string_literal: true

class Hangman
  attr_accessor :wrong_guesses_remaining, :total_guesses, :wrong_guesses, :correct_guesses

  def initialize
    @wrong_guesses_remaining = 6
    @total_guesses = 0
    @wrong_guesses = []
    @correct_guesses = []
    @random_word = []
  end

  def choose_random_word(text_file)
    File.open text_file do |file|
      file.readlines.sample.chomp
    end
  end

  def player_guess
    print 'Guess a letter: '
    player_input = gets.chomp
    unless [*'a'..'z'].include?(player_input.downcase)
      puts 'Please enter a valid letter.'
      player_guess
    end
    player_input
  end
end
