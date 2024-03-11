# frozen_string_literal: true

require_relative 'display'
require_relative 'file_work'

TOTAL_AVAILABLE_GUESSES = 7

# hangman's game class
class Game
  attr_accessor :tried_letters, :guessing_word, :left_guesses

  include Display
  include FileWork

  def initialize
    @tried_letters = []
    @guessing_word = nil
    @left_guesses = TOTAL_AVAILABLE_GUESSES
  end

  def play
    loaded_file_name = nil
    prompt_for_loading_game == 'y' ? loaded_file_name = choose_game_to_load : choose_guessing_word

    loop do
      input = guess_letter

      return save_game(loaded_file_name) if input == 'exit'

      process_input(input)

      break if finished_game?
    end

    process_end_of_game(loaded_file_name)
  end

  private

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
    @left_guesses -= 1 unless guessing_word.chars.include?(input)
  end

  def finished_game?
    left_guesses <= 0 || guessing_word.chars.all? { |letter| tried_letters.include?(letter) }
  end

  def process_end_of_game(file_name)
    left_guesses.positive? ? winning_text : losing_text
    delete_file(file_name) unless file_name.nil?
  end
end
