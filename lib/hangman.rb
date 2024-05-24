# frozen_string_literal: true

class Hangman
  attr_accessor :guesses_remaining, :total_guesses, :guesses_tried, :display_correct_guesses, :player_input

  def initialize
    @guesses_remaining = 6
    @total_guesses = 0
    @guesses_tried = []
    @word = choose_word('words.txt').split('')
    @display_correct_guesses = @word.map { |_| '_' }
    @player_input = nil
    @number_of_saved_games = Dir.open('saved_games').count - 2
  end

  def play
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
      save_game(self, @number_of_saved_games + 1)
      @number_of_saved_games += 1
      puts "Game successfully saved.\n\n"
      exit
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

  def save_game(object, num)
    yaml_string = object.to_yaml
    File.open("saved_games/save_#{num}.yml", 'w') do |file|
      file.write(yaml_string)
    end
  end

  attr_reader :word
end
