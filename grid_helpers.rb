require_relative 'grid'

module GridHelpers
  # use this to determine available moves on the grid
  def available_columns
    x = 0

    results = @heaps.each_index.select{|i| @heaps[i] > 0}

    results
  end
end
