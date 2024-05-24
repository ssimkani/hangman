# frozen_string_literal: true

# This class contains the main logic for playing hangman. It includes methods such as
# displaying the game and handling the player guesses.
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
    # Main method for playing the game and displaying if the user won or lost.
    display until guesses_remaining.zero? || (word == display_correct_guesses)
    display
    puts "\n\nGAME OVER"
    puts 'YOU WIN' if word == display_correct_guesses
    puts "YOU LOSE\nThe word was: #{word.join}" if guesses_remaining.zero?
  end

  def display_hangman
    # Displays the hangman stage based on the number of guesses remaining.
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
    # Displays the hangman, the word to be guessed, total guesses, and guesses tried
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
    # Chooses a random word from the word.txt file.
    File.open text_file do |file|
      file.readlines.sample.chomp.upcase
    end
  end

  def player_guess
    # Gets the players input and checks if it is valid or not
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
    # Determines if the letter guessed is in the word or the player wants to save their game
    if word.include?(letter)
      replace(letter)
    elsif letter == '2'
      @number_of_saved_games += 1
      save_game(self, @number_of_saved_games)
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
    # Replaces the '_' in the display word with the guessed letter
    arr = []
    word.each_with_index { |char, index| arr << index if char == letter }
    arr.each { |index| display_correct_guesses[index] = letter }
    @total_guesses += 1
    guesses_tried << letter.upcase
    display_correct_guesses
  end

  def save_game(object, num)
    # Saves the game to a yaml file in the saved_games directory
    yaml_string = object.to_yaml
    File.open("saved_games/save_#{num}.yml", 'w') do |file|
      file.write(yaml_string)
    end
  end

  attr_reader :word
end
