# frozen_string_literal: true

class Hangman
  attr_accessor :wrong_guesses_remaining, :total_guesses, :wrong_guesses, :correct_guesses, :random_word

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

  def display
    @random_word = choose_random_word('words.txt').split('')
    correct_guesses = @random_word.map { |_| '_ ' }
    print '------------------------------------------------------------'
    print "------------------------------------------------------------\n\n\n\n\n\n\n\n\n\n\n"
    print "#{correct_guesses.join}\t"
    print "Wrong Guesses Remaining: #{wrong_guesses_remaining}\t Total Guesses: #{total_guesses}\t"
    print "Tried: #{wrong_guesses.join(', ')}\n"
  end

  def player_guess
    print "\n\nGuess a letter: "
    player_input = gets.chomp
    unless [*'a'..'z'].include?(player_input.downcase)
      puts 'Please enter a valid letter.'
      player_guess
    end
    player_input
  end
end
