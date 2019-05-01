module MatrixParsing

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

  private

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
