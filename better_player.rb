require_relative 'player'

class BetterPlayer < Player
  attr_accessor :color, :opponent

  def initialize
    @color = 'fuchsia'
  end

  def play_round(grid)
    grid.available_columns.each do |col|
      if grid.is_winning_move_for?(@color, col)
        # Win!
        return col
      elsif grid.is_winning_move_for?(opponent, col)
        # Prevent the opponent from winning
        return col
      end
    end

    not_losing_moves = grid.available_columns.map do |col|
      dg = dup_grid(grid)
      dg.drop_in_column(@color, col)

      if dg.is_winning_move_for?(opponent, col)
        # Can't move here, otherwise the opponent can win by placing a game piece on top of it
        nil
      else
        # Wouldn't cause us to lose IMMEDAIATELY... so take it
        col
      end
    end.compact

    if not_losing_moves.empty?
      # Forfeit - there's no winning move
      return grid.available_columns[rand(grid.available_columns.length)]
    end

    # Pick a random move that won't cause us to lose next turn
    not_losing_moves[rand(not_losing_moves.length)]
  end

  private

  def dup_grid(grid)
    Marshal.load(Marshal.dump(grid))
  end
end
