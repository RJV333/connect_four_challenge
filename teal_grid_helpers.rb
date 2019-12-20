require_relative 'grid'

module TealGridHelpers
  # use this to determine available moves on the grid
  def is_losing_move_for?(color, opponent_color, column)
    copy_grid = Marshal.load( Marshal.dump(self) ) #deep copy
    copy_grid.drop_in_column(color, column)

    copy_grid.available_columns.each do |col|
      return true if is_winning_move_for?(opponent_color, col)
    end

    return false
  end

  def three_n_streaks(color)
    horizontal_n_streaks(color) +
    vertical_n_streaks(color) +
    diagonal_n_streaks(color)
  end

  def horizontal_n_streaks(color)
  end

  def vertical_n_streaks(color)
  end

  def diagonal_n_streaks(color)
  end

  def value_of_game_board(color)
  end
end
