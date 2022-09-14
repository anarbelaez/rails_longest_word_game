require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
    @time = Time.now
  end

  def score
    time = params[:time] || Time.now.to_s
    @message = score_and_message(params[:letters], time, params[:word])[1]
    session[:score] ||= 0
    session[:score] += score_and_message(params[:letters], time, params[:word])[0]
  end

  private

  def generate_grid
    # Generamos la grid con 4 vocales y 5 consonantes
    alphabet = ('a'..'z').to_a
    vowels = %w[a e i o u]
    consonants = alphabet - vowels
    grid = []
    9.times { |i| i <= 4 ? grid << vowels.sample : grid << consonants.sample }
    grid.shuffle
  end

  def word_in_grid?(attempt, letters)
    # El intento lo pasamos a array y con el enumerable all?
    # pasamos cada letra por el bloque donde se ejecuta una condicion
    # Con count se suma el numero de veces que aparece la letra y se compara con
    # el numero de veces que aparece en la letters dada. Si todos estos pasan all? devuelve
    # true, de lo contrario devuelve false
    attempt.chars.all? { |letter| attempt.count(letter) <= letters.count(letter) } if attempt
  end

  def english_word?(attempt)
    # Consultamos si la palabra ingresada es una palabra en ingles
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    query = URI.open(url).read
    result = JSON.parse(query)
    result['found']
  end

  def compute_score(attempt, time)
    time_attempt = Time.now - Time.parse(time)
    time_attempt >= 30 ? 0 : attempt.size
  end

  def score_and_message(grid, time, attempt)
    case attempt
    when nil
      [0, 'Do you want to play again? Click the button!']
    else
      if !word_in_grid?(attempt, grid)
        [0, "Sorry, but #{attempt.upcase} can't be built out or #{grid.upcase.gsub(' ', '-')}"]
      elsif word_in_grid?(attempt, grid) && !english_word?(attempt)
        [0, "Sorry, but #{attempt.upcase} does not seem to be a valid English word!"]
      else
        score = compute_score(attempt, time)
        [score, "Congratulations! #{attempt.upcase} is a valid English word!"]
      end
    end
  end
end
