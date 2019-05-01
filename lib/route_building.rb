module RouteBuilding

  def build_route(distances_matrix)
    route = []
    matrix_casting distances_matrix
    while get_row_number(distances_matrix) >= 2
      path = find_part_of_path distances_matrix
      route << path
      remove_row_and_col(distances_matrix, path[0],path[1])
      remove_inverted_path(distances_matrix, path[1], path[0])
    end
    route << get_closing_path(distances_matrix)
    route.sort
  end

  private

  def matrix_casting(distances_matrix)
    distances_matrix.each do |row|
      min = row.min
      row.map! do |elem|
        elem - min
      end
    end
    distances_matrix.transpose.each do |row|
      min = row.min
      row.map! do |elem|
        elem - min
      end
    end.transpose
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
        if elem == 0
          d = find_min_except(row, j) + find_min_except(distances_matrix.transpose[j],i)
          if d > max
            max = d
            source = i
            destination = j
          end
        end
      end
    end
    [source, destination]
  end

  def get_closing_path(distances_matrix)
    distances_matrix.each_with_index do |row, i|
      row.each_with_index do |elem, j|
        unless elem == Float::INFINITY
          return [i,j]
        end
      end
    end
  end

  def remove_row_and_col(distances_matrix, row_index, col_index)
    distances_matrix[row_index].map! do |elem|
      Float::INFINITY
    end
    distances_matrix = distances_matrix.each do |row|
      row[col_index] = Float::INFINITY
    end
  end

  def remove_inverted_path(distances_matrix, row_index, col_index)
    distances_matrix[row_index][col_index] = Float::INFINITY
  end

  def get_row_number(distances_matrix)
    rows = 0
    distances_matrix.each do |row|
      unless row - [Float::INFINITY] == []
        rows += 1
      end
    end
    rows
  end

end
