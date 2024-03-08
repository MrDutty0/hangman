# frozen_string_literal: true

require_relative 'display'

TOTAL_AVAILABLE_GUESSES = 7

# hangman's game class
class Game
  attr_accessor :tried_letters, :guessed_letters, :guessing_word, :left_guesses

  include Display

  def initialize
    @tried_letters = []
    @guessed_letters = []
    @guessing_word = nil
    @left_guesses = TOTAL_AVAILABLE_GUESSES
  end

  def choose_guessing_word
    File.open('words.txt', 'r') do |file|
      words = file.read.split

      available_words = words.select { |word| word.length >= 5 && word.length <= 12 }

      @guessing_word = available_words.sample
    end
  end

  def play
    choose_guessing_word

    loop do
      input = guess_letter
    end
  end

  def guess_letter
    error_count = 0
    prompt_text = 'Please enter a single letter to guess or "exit" to exit the game'
    error_msg = nil

    loop do
      display_game
      puts prompt_text
      puts "#{error_msg}(#{error_count})" unless error_count.zero?

      input = gets.chomp.downcase

      error_msg = check_input(input)

      clear_screen
      if error_msg.nil?
        display_game
        return input
      end

      error_count += 1
    end
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
end
