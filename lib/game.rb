# frozen_string_literal: true

require_relative 'display'

TOTAL_AVAILABLE_GUESSES = 7

# hangman's game class
class Game
  attr_accessor :tried_letters, :guessed_letters, :guessing_word, :left_guesses

  include Display

  def initialize
    @tried_letters = []
    @guessing_word = nil
    @left_guesses = TOTAL_AVAILABLE_GUESSES
  end

  def play
    if prompt_for_loading_game == 'y'
      # choose_game_to_load
    else
      choose_guessing_word
    end

    loop do
      input = guess_letter

      process_input(input)

      break if finished_game?
    end
  end

  private

  def choose_guessing_word
    File.open('words.txt', 'r') do |file|
      words = file.read.split

      available_words = words.select { |word| word.length >= 5 && word.length <= 12 }

      @guessing_word = available_words.sample
    end
  end

  def check_input(input)
    error_msg = nil

    if input != 'exit' && input.length != 1
      error_msg = 'Please enter a single character or "exit" to exit the game'
    elsif input =~ /^[^a-z]$/i
      error_msg = 'Please enter a letter character'
    elsif tried_letters.include?(input)
      error_msg = 'You have already tried this letter'
    end

    error_msg
  end

  def process_input(input)
    tried_letters << input
    @left_guesses -= 1 unless guessing_word.split('').include?(input)
  end

  def finished_game?
    left_guesses <= 0 || guessing_word.split('').all? { |letter| tried_letters.include?(letter) }
  end
end
