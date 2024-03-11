# frozen_string_literal: true

require 'colorize'
require 'io/console'

ALPHABET = ('A'..'Z').to_a.freeze

# For displaying information for the user
module Display
  def display_game
    formatted_word = guessing_word.chars.map do |letter|
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
    system('clear') || system('cls')
  end

  def guess_letter
    error_count = 0
    prompt_text = 'Please enter a single letter to guess or "exit" to exit the game'
    error_msg = nil

    loop do
      clear_screen
      display_game
      puts prompt_text
      puts "#{error_msg}(#{error_count})" unless error_count.zero?

      input = gets.chomp.downcase

      error_msg = check_input(input)

      return input if error_msg.nil?

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

  def get_file_id(file_stems)
    no_files = file_stems.length
    error_no = 0

    input = nil
    loop do
      print_saved_files(file_stems, error_no)

      input = gets.chomp

      break if correct_file_id?(input, no_files)

      error_no += 1
    end

    input.to_i
  end

  def correct_file_id?(input, no_files)
    input =~ /^[0-9]+$/ && input.to_i < no_files
  end

  def print_saved_files(file_names, error_no)
    clear_screen

    prompt_text = 'Choose the game_id of game you want to load'
    prompt_text += "(#{error_no})" unless error_no.zero?

    puts prompt_text
    puts 'id | file name'
    puts '------------------------'
    file_names.each_with_index do |file_name, i|
      puts "#{i}  | #{file_name}"
    end
  end

  def winning_text
    clear_screen
    puts 'Congratulations, your pal has survived! You are a hero!'
  end

  def losing_text
    clear_screen
    puts 'Unfortunately, you did not manage to save your friend.'
    puts "The word was #{guessing_word}"
  end
end
