# frozen_string_literal: true

require 'colorize'
require 'io/console'

ALPHABET = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'].freeze

# For displaying information for user
module Display
  def display_game
    formatted_word = guessing_word.split('').map do |letter|
      tried_letters.include?(letter) ? letter.colorize(mode: :underline) : '_'
    end

    formatted_alphabet = ALPHABET.map do |letter|
      tried_letters.include?(letter.downcase) ? letter.colorize(mode: :dim) : letter
    end

    puts "Left guesses: #{left_guesses}"
    puts "#{formatted_word.join(' ')}\n\n"
    puts "#{formatted_alphabet.join(', ')}\n\n"
  end

  def clear_screen
    puts "\e[2J"
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

  def prompt_for_loading_game
    puts "Type 'y' to load a saved game, or any other key to start a new game"

    input = prompt_for_single_char.downcase
    clear_screen
    input
  end

  def prompt_for_single_char
    input = $stdin.getch
    begin
      input += $stdin.read_nonblock(2)
    rescue IO::EAGAINWaitReadable
      nil
    end
    input
  end
end
