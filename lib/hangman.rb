# frozen_string_literal: true

class Hangman
  attr_accessor :guesses_remaining, :wrong_guesses, :correct_guesses

  def initialize
    @guesses_remaining = 6
    @wrong_guesses = []
    @correct_guesses = []
    @random_word = []
  end

  def choose_random_word(text_file)
    File.open text_file do |file|
      file.readlines.sample.chomp
    end
  end
end
