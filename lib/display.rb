# frozen_string_literal: true

require 'colorize'

ALPHABET = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

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
end
