require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
    @time = Time.now
  end

  def score
    attempt = params[:word]
    letters = params[:letters]
    time = params[:time] || Time.now.to_s
    @time_attempt = Time.now - Time.parse(time)
    @message = if !word_in_grid?(attempt, letters)
                 'The word does not exist in the grid'
               elsif word_in_grid?(attempt, letters) && !english_word?(attempt)
                 'The word must be an english word!!'
               else
                 'You win!!'
               end
  end

  private

  def generate_grid
    alphabet = ('a'..'z').to_a
    vowels = %w[a e i o u]
    consonants = alphabet - vowels
    # grid = []
    # 4.times { grid << vowels.sample }
    # 6.times { grid << consonants.sample }
    grid = vowels.sample(4) + consonants.sample(5)
    grid.shuffle
  end

  def word_in_grid?(attempt, grid)
    # El intento lo pasamos a array y con el enumerable all?
    # pasamos cada letra por el bloque donde se ejecuta una condicion
    # Con count se suma el numero de veces que aparece la letra y se compara con
    # el numero de veces que aparece en la grid dada. Si todos estos pasan all? devuelve
    # true, de lo contrario devuelve false
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) } if attempt
  end

  def english_word?(attempt)
    # Consultamos si la palabra ingresada es una palabra en ingles
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    query = URI.open(url).read
    result = JSON.parse(query)
    result['found']
  end
end
