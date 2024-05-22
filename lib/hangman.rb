# frozen_string_literal: true

class Hangman
  attr_accessor :guesses_remaining, :total_guesses, :guesses_tried, :display_correct_guesses

  def initialize
    @guesses_remaining = 6
    @total_guesses = 0
    @guesses_tried = []
    @display_correct_guesses = []
    @word = []
  end

  def choose_word(text_file)
    File.open text_file do |file|
      file.readlines.sample.chomp
    end
  end

  def display
    word = choose_word('words.txt').split('')
    display_correct_guesses = word.map { |_| '_ ' }
    print '------------------------------------------------------------'
    print "------------------------------------------------------------\n\n\n\n\n\n\n\n\n\n\n"
    print "#{display_correct_guesses.join}\t"
    print "Wrong Guesses Remaining: #{guesses_remaining}\t Total Guesses: #{total_guesses}\t"
    print "Tried: #{guesses_tried.join('  ')}\n"
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

  def check_guess(letter)
    if word.include?(letter)
      replace(letter)
    else
      @guesses_remaining -= 1
      @total_guesses += 1
      guesses_tried << letter.upcase
    end
  end

  def replace(letter)
    arr = []
    word.each_with_index { |char, index| arr << index if char == letter }
    arr.each { |index| display_correct_guesses[index] = letter }
    @total_guesses += 1
    guesses_tried << letter.upcase
    display_correct_guesses
  end

  private

  attr_accessor :word
end
