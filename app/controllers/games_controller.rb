require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    session[:score] = 0 unless session.key?(:score)
    @score = session[:score]
    alphabet = %w[A A A B C D E E E F G H I I J K L M N O O P Q R S T U U V W X Y Z]
    @ten_letters = []
    10.times do
      @ten_letters << alphabet.sample
    end
  end

  def score
    @is_valid = true
    @score = session[:score]
    game_letters = params[:letters].split
    game_letters_comma = game_letters.join(", ")
    word = params[:answer].upcase
    @message = "Sorry, but #{word} does not seem to be a valid English word..."
    word.each_char do |letter|
      if game_letters.include?(letter)
        game_letters.delete_at(game_letters.index(letter))
      else
        @is_valid = false;
        @message = "Sorry, but #{word} can't be built out of #{game_letters_comma}"
        break
      end
    end
    url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    serialized_data = URI.open(url).read
    data = JSON.parse(serialized_data)
    p data["found"]
    p @is_valid
    if data["found"] && @is_valid
      @message = "#{word} is a valid English word!"
      @word_score = word.length * word.length
      session[:score] += @word_score
    else
      @is_valid = false
    end
  end

  def reset
    session[:score] = 0
    @score = session[:score]
    alphabet = %w[A A A B C D E E E F G H I I J K L M N O O P Q R S T U U V W X Y Z]
    @ten_letters = []
    10.times do
      @ten_letters << alphabet.sample
    end
  end
end
