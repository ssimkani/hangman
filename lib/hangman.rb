# frozen_string_literal: true

class Hangman
  def initialize; end
end

def choose_random_word(text_file)
  File.open text_file do |file|
    file.readlines.sample.chomp
  end
end
