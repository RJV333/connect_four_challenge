class TealPlayer < Player

  def init
    @color = 'teal'
  end

  def play_round( grid )
    # if winning move, take it
    grid.available_columns.each do |col|
      return col if grid.is_winning_move_for?(@color, col)
    end
    # if opponent on verge of winning, block it
    grid.available_columns.each do |col|
      return col if grid.is_winning_move_for?(@opponent, col)
    end
    # else do any remaining moves put opponent on verge of winning?
    remaining_moves = grid.available_columns
      .reject { |col| grid.is_losing_move_for?(@color, @opponent_color, col) }
    # else move with the high number of n-streaks
    remaining_moves[ rand(remaining_moves.length) ]
  end
end
