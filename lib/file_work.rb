# frozen_string_literal: true

require 'json'
require 'time'
require_relative 'display'

# Retrieving information and working with files
module FileWork
  SAVES_DIR_NAME = 'game_saves'
  WORD_FILE_NAME = 'words.txt'
  def choose_guessing_word
    words = File.readlines(WORD_FILE_NAME, chomp: true)

    available_words = words.select { |word| word.length.between?(5, 12) }

    @guessing_word = available_words.sample
  end

  def choose_game_to_load
    ensure_saves_directory_exists
    file_name = select_file_to_load
    load_file(file_name)
    file_name
  end

  def ensure_saves_directory_exists
    Dir.mkdir(SAVES_DIR_NAME) unless Dir.exist?(SAVES_DIR_NAME)
  end

  def select_file_to_load
    file_stems = Dir.children(SAVES_DIR_NAME).map { |file_name| file_name.split('.').first }
    file_id = get_file_id(file_stems)
    Dir.children(SAVES_DIR_NAME)[file_id]
  end

  def load_file(file_name)
    data = JSON.parse(File.read("#{SAVES_DIR_NAME}/#{file_name}"))
    data.each { |key, value| send("#{key}=", value) }
  end

  def save_game(loaded_file_name)
    delete_file(loaded_file_name) unless loaded_file_name.nil?

    time_formatted = Time.now.strftime('%Y-%m-%d_%H:%M:%S')
    file_path = "#{SAVES_DIR_NAME}/#{time_formatted}.json"

    save_data_to_file(file_path)
  end

  def save_data_to_file(file_path)
    File.open(file_path, 'w') do |file|
      data = collect_instance_variables
      JSON.dump(data, file)
    end
  end

  def collect_instance_variables
    instance_variables.each_with_object({}) do |variable, res|
      key = variable[1..].to_sym
      res[key] = instance_variable_get(variable)
    end
  end

  def delete_file(file_name)
    File.delete("#{SAVES_DIR_NAME}/#{file_name}")
  end
end
