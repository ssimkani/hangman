# frozen_string_literal: true

require_relative 'game'

class Hangman < Game
  attr_accessor :guesses_remaining, :total_guesses, :guesses_tried, :display_correct_guesses, :player_input

  def initialize
    super
    @guesses_remaining = 6
    @total_guesses = 0
    @guesses_tried = []
    @display_correct_guesses = []
    @word = []
    @player_input = nil
    @number_of_saved_games = 0
  end

  def play
    initialize # this ensures that the game is re-initialized every time the play method is called
    @word = choose_word('words.txt').split('') until word.length >= 5
    @display_correct_guesses = word.map { |_| '_' }
    display until guesses_remaining.zero? || (word == display_correct_guesses)
    display
    puts "\n\nGAME OVER"
    puts 'YOU WIN' if word == display_correct_guesses
    puts "YOU LOSE\nThe word was: #{word.join}" if guesses_remaining.zero?
    puts 'Enter 1 to play again or 0 to exit'
    input = gets.chomp
    if input == '1'
      play
    else
      exit
    end
  end

  def display_hangman
    stages = [
      '
     --------
     |      |
     |      O
     |     \|/
     |      |
     |     / \
     -
  ',
      '
     --------
     |      |
     |      O
     |     \|/
     |      |
     |     /
     -
  ',
      '
     --------
     |      |
     |      O
     |     \|/
     |      |
     |
     -
  ',
      '
     --------
     |      |
     |      O
     |     \|
     |      |
     |
     -
  ',
      '
     --------
     |      |
     |      O
     |      |
     |      |
     |
     -
  ',
      '
     --------
     |      |
     |      O
     |
     |
     |
     -
  ',
      '
     --------
     |      |
     |
     |
     |
     |
     -
  '
    ]
    stages[guesses_remaining]
  end

  def display
    print '------------------------------------------------------------'
    print "------------------------------------------------------------\n\n"
    puts display_hangman
    print "Word:\t#{display_correct_guesses.join(' ')}\t"
    print "Total Guesses: #{total_guesses}\t"
    print "Guesses Tried: #{guesses_tried.join('  ')}\n"
    return if guesses_remaining.zero? || (word == display_correct_guesses)

    if check_guess(player_guess).nil?
      print "Sorry, '#{player_input}' is not in the word.\n"
    else
      print "'#{player_input}' is in the word!\n"
    end
  end

  protected

  def choose_word(text_file)
    File.open text_file do |file|
      file.readlines.sample.chomp.upcase
    end
  end

  def player_guess
    print "\n\nGuess a letter: "
    @player_input = gets.chomp.upcase
    if ([*'A'..'Z'].include?(player_input) && !guesses_tried.include?(player_input)) || player_input == '2'
      player_input
    else
      puts 'Please enter a valid letter that you have not guessed before.'
      player_guess
    end
  end

  def check_guess(letter)
    if word.include?(letter)
      replace(letter)
    elsif letter == '2'
      to_yaml(self, @number_of_saved_games + 1)
      @number_of_saved_games += 1
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

  attr_reader :word
end
