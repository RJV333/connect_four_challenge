require_relative 'Player'

class AquaTaco < Player
  attr_accessor :color, :opponent

  def init
    @color = 'aqua'
  end

  def play_round(grid)
    grid.available_columns.each do |c|
      if grid.is_winning_move_for?(@color, c)
        return c
      elsif grid.is_winning_move_for?(self.opponent, c)
        return c
      elsif has_two_opponent_neighbors?(c, grid)
        return c
      end
    end

    occupied_by_us = grid.occupied_spaces.select do |s|
      grid.occupied_spaces[s] == self.color
    end
    occupied_by_us.keys.each do |s|
      grid.all_surrounding_spaces(s).each do |t|
        if grid.open_space?(t)
          return t % grid.columns_size
        end
      end
    end
    grid.available_columns[ rand(grid.available_columns.length) ]
  end

  def has_two_opponent_neighbors?(column, grid)
    g = grid
    return false if column < 1 or column > 5

    spot = grid.lowest_available_row_in_column(column)
    left = spot - 1
    right = spot + 1

    g.occupied_spaces[left] == self.opponent and g.occupied_spaces[right] == self.opponent
  end
end
