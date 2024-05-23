# frozen_string_literal: true

class Hangman
  attr_accessor :guesses_remaining, :total_guesses, :guesses_tried, :display_correct_guesses, :player_input

  def initialize
    @guesses_remaining = 6
    @total_guesses = 0
    @guesses_tried = []
    @display_correct_guesses = []
    @word = []
    @player_input = nil
  end

  def play
    @word = choose_word('words.txt').split('') until word.length >= 5
    @display_correct_guesses = word.map { |_| '_' }
    display until guesses_remaining.zero? || (word == display_correct_guesses)
    puts "\n\nGAME OVER"
    puts 'YOU WIN' if word == display_correct_guesses
    puts 'YOU LOSE' if guesses_remaining.zero?
  end

  def choose_word(text_file)
    File.open text_file do |file|
      file.readlines.sample.chomp.upcase
    end
  end

  def display
    print '------------------------------------------------------------'
    print "------------------------------------------------------------\n\n\n\n\n\n\n\n\n\n\n"
    print "Word:\t#{display_correct_guesses.join(' ')}\t\t"
    print "Wrong Guesses Remaining: #{guesses_remaining}\t Total Guesses: #{total_guesses}\t"
    print "Tried: #{guesses_tried.join('  ')}\n"
    p display_correct_guesses
    p word
    if check_guess(player_guess).nil?
      print "Sorry, '#{player_input}' is not in the word.\n"
    else
      print "'#{player_input}' is in the word!\n"
    end
  end

  def player_guess
    print "\n\nGuess a letter: "
    @player_input = gets.chomp.upcase
    if [*'A'..'Z'].include?(player_input) && !guesses_tried.include?(player_input)
      player_input
    else
      puts 'Please enter a valid letter that you have not guessed before.'
      player_guess
    end
  end

  def check_guess(letter)
    if word.include?(letter)
      replace(letter)
    else
      @guesses_remaining -= 1
      @total_guesses += 1
      guesses_tried << letter
      nil
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

  attr_reader :word
end

Hangman.new.play
