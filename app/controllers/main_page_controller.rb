# frozen_string_literal: true

class MainPageController < ActionController::Base

  include RouteBuilding
  include MatrixParsing

  def index; end

  def create
    render plain: build_route(parse_length_matrix(params))
  end

end
