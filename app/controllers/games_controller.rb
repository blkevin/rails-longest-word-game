require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabet[rand(1..25)]
    end
    @letters
  end

  def score
    @letters = params[:letters]
    word = params[:word]
    if included?(word, @letters) == true
      if english_word?(word) == true
        @result = "Congratulations! #{word.capitalize} is a valid English word!"
      else
        @result = "Sorry but #{word.capitalize} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{word.capitalize} cannot be build out of #{@letters.join(", ")}"
    end
  end

  def included?(word, letters)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json["found"]
  end
end
