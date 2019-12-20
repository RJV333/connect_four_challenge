require_relative 'grid'

module GridHelpers
  # use this to determine available moves on the grid
  def available_columns
    x = 0
    results = []

    while x < @columns_size do
      if !topped_column?(x)
        results << x
      end
      x += 1
    end

    results
  end

  # col, row_height (0 indexed) to int represeing position on grid,
  # not necessary to use, though maybe you'll find helpful
  def xy_to_spot(x, y)
    spot = x + (y * @columns_size)
  end
  def spot_to_xy(spot)
    x = spot % columns_size
    y = spot / columns_size
    return [ x, y ]
  end

  # does playing this column_number result in a winning state?
  def is_winning_move_for?(color, column)
    copy_grid = Marshal.load( Marshal.dump(self) ) #deep copy
    copy_grid.drop_in_column(color, column)
    copy_grid.winning_state?
  end

  # returns integer (0,42), representing 'spot' on grid
  # this is the playable spot from being dropped in a column
  def lowest_available_row_in_column(col_number)
    spot = nil

    index = col_number

    while spot.nil? do
      if open_space?(index)
        spot = index
      else
        index += @columns_size
      end
    end

    spot
  end

  # is this spot on the board open and unplayed?
  def open_space?(spot)
    !@occupied_spaces.key?(spot)
  end

  # up to 8 integers representing the up to 8 tiles around a grid location.
  def all_surrounding_spaces(spot)
    to_check = []
    to_check << spot - 1 if (spot % @columns_size != 0)
    to_check << (spot - @columns_size - 1) if (spot % @columns_size != 0)
    to_check << (spot + @columns_size - 1) if (spot % @columns_size != 0)

    to_check << spot + 1 if (spot % @columns_size != 6)
    to_check << (spot - @columns_size + 1) if (spot % @columns_size != 6)
    to_check << (spot + @columns_size + 1) if (spot % @columns_size != 6)

    to_check << spot + @columns_size
    to_check << spot - @columns_size

    to_check.select{ |numero| numero >= 0 && numero < @upper_bound}
  end

  # subhash representing all played, contingent tiles to a grid location
  # hash is also in form { tile_integer => player_color }
  def occupied_neighbors(spot)
    sub_hash = {}

    all_surrounding_spaces(spot).each do |ss|
      sub_hash[ss] = @occupied_spaces[ss] if @occupied_spaces.key?(ss)
    end
    sub_hash
  end
end
