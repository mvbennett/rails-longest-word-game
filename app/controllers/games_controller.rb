require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters = ("A".."Z").to_a
    @grid = []
    10.times { @grid << letters[rand(0..25)] }
  end

  def score
    @word = params[:word]
    @grid = params[:grid].chars
    grid_tally = @grid.tally
    word_tally = @word.upcase.chars.tally
    @in_grid = true
    word_tally.each do |key, val|
      @in_grid = false if grid_tally[key].nil? || val > grid_tally[key]
    end
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = URI.parse(url).open.read
    word_hash = JSON.parse(word_serialized)
    @english = word_hash['found']
    @result = if @in_grid == false
                "Sorry #{@word} can't be made from #{@grid.join(', ')}"
              elsif @english == false
                "Sorry, that isn't an English word."
              else
                'Great jorb!'
              end
  end
end
