# frozen_string_literal: true

module RouteBuilding

  def build_route(params)
    distances_matrix = parse_length_matrix(params)
    route = []
    while get_row_number(distances_matrix) >= 2
      matrix_casting distances_matrix
      path = find_part_of_path distances_matrix
      route << path
      distances_matrix = remove_row_and_col(distances_matrix, path[0], path[1])
      remove_inverted_path(distances_matrix, path[1], path[0])
    end
    route << get_closing_path(distances_matrix)
    make_address_sequence route, JSON.parse(params[:address_array])
  end

  def matrix_casting(distances_matrix)
    is_casted = false
    distances_matrix.each do |row|
      if row.include?(0)
        is_casted = true
        break
      end
    end
    return if is_casted

    distances_matrix.each do |row|
      min = row.min
      raise ArgumentError if min == Float::INFINITY
    rescue ArgumentError
      puts 'empty row'
    else
      row.map! do |elem|
        elem - min
      end
    end
    distances_matrix.transpose.each do |row|
      min = row.min
      raise ArgumentError if min == Float::INFINITY
    rescue ArgumentError
      puts 'empty col'
    else
      row.map! do |elem|
        elem - min
      end
    end
  end

  def find_min_except(vector, index_except)
    min = Float::INFINITY
    vector.each_with_index do |elem, index|
      min = elem if index != index_except && elem < min
    end
    min
  end

  def find_part_of_path(distances_matrix)
    max = 0
    source = 0
    destination = 0
    distances_matrix.each_with_index do |row, i|
      row.each_with_index do |elem, j|
        next unless elem == 0
        d = find_min_except(row, j) + find_min_except(distances_matrix.transpose[j],i)
        next unless d > max
        max = d
        source = i
        destination = j
      end
    end
    [source, destination]
  end

  def get_closing_path(distances_matrix)
    distances_matrix.each_with_index do |row, i|
      row.each_with_index do |elem, j|
        return [i,j] unless elem == Float::INFINITY
      end
    end
  end

  def remove_row_and_col(distances_matrix, row_index, col_index)
    distances_matrix[row_index].map! do |_elem|
      Float::INFINITY
    end
    distances_matrix.each do |row|
      row[col_index] = Float::INFINITY
    end
  end

  def remove_inverted_path(distances_matrix, row_index, col_index)
    distances_matrix[row_index][col_index] = Float::INFINITY
  end

  def get_row_number(distances_matrix)
    rows = 0
    distances_matrix.each do |row|
      rows += 1 unless row - [Float::INFINITY] == []
    end
    rows
  end

  def make_address_sequence(route_pairs, addresses)
    return addresses if route_pairs.length == 2

    route = Array.new(route_pairs.length)
    route[0] = 0
    for i in 1..route_pairs.length-1
      route[i] = route_pairs.assoc(route[i-1])[1]
    end
    result = Array.new(route.length)
    route.each_with_index do |elem, index|
      result[index] = addresses[elem]
    end
    result
  end

  def parse_length_matrix(params)
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
  end

  def parse_length_string_to_meters(string)
    regex = /(?<length>\d+)(,(?<dot>\d))?.(?<measure>(км|м))/
    if (res = string.match regex)
      if res['measure'] == 'км'
        res['length'].to_i * 1000 + res['dot'].to_i * 100
      else
        res['length'].to_i
      end
    end
  end

end
