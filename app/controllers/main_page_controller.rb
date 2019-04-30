# frozen_string_literal: true

class MainPageController < ActionController::Base
  def index; end

  def create
    length_matrix = JSON.parse params[:length_matrix]
    length_matrix.map! do |row|
      row.map! do |elem|
        if elem.nil?
          Float::INFINITY
        else
          parse_length_string_to_meters elem
        end
      end
    end
    render plain: length_matrix.inspect
  end

  private

  def parse_length_string_to_meters(string)
    regex = /(?<length>\d+)(,(?<dot>\d))?.(?<measure>(км|м))/
    if string.match? regex
      res = string.match regex
      length = if res['measure'] == 'км'
                 res['length'].to_i * 1000 + res['dot'].to_i * 100
               else
                 res['length']
               end
      length
    end
  end
end
