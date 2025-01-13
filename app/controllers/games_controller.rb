require 'net/http'
require 'uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @score = 0
    @message = ""

    if valid_word_in_grid?(@word, @letters)
      if valid_english_word?(@word)
        @score = calculate_score(@word)
        @message = "Congratulations! '#{@word}' is a valid word!"
      else
        @message = "Sorry but '#{@word}' does not seem to be a valid word..."
      end
    else
      @message = "Sorry but '#{@word}' can't be built out of #{@letters.join(', ')}"
    end
  end

  private

  def valid_word_in_grid?(word, letters)
    grid_letters = letters.dup
    word.chars.each do |letter|
      if grid_letters.include?(letter)
        grid_letters.delete_at(grid_letters.index(letter))
      else
        return false
      end
    end
    true
  end

  def valid_english_word?(word)
    uri = URI.parse("https://dictionary.lewagon.com/#{word}")
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      return result["found"]
    else
      false
    end
  end

  def calculate_score(word)
    word.length
  end
end
