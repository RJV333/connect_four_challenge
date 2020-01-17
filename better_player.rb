require_relative 'player'

class BetterPlayer < Player
  attr_accessor :color, :opponent

  def initialize
    @color = 'fuchsia'
  end

  def play_round(grid)
    @grid = grid

    grid.available_columns.each do |col|
      if grid.is_winning_move_for?(@color, col)
        # Win!
        return col
      end
    end

    # No immediately winning moves; prevent the opponent from winning
    grid.available_columns.each do |col|
      if grid.is_winning_move_for?(opponent, col)
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
    end

    if not_losing_moves.compact.empty?
      # Forfeit - there's no winning move
      return grid.available_columns[grid.available_columns.sample]
    end

    cx, cy = center_of_mass(@color)

    dist_groups = not_losing_moves
      .compact
      .map { |col| [col, grid.spot_to_xy(grid.lowest_available_row_in_column(col))[1]] }
      .group_by { |point| dist(point, [cx, cy]) }

    dist_groups[dist_groups.keys.min].sample.first
  end

  private

  attr_reader :grid

  def dup_grid(grid)
    Marshal.load(Marshal.dump(grid))
  end

  def dist(p1, p2)
    Math.sqrt(
      (p1[0] - p2[0])**2 + 
      (p1[1] - p2[1])**2
    )
  end

  def open_spaces
    open_spaces = []
    (0..6).each do |col|
      row = grid.spot_to_xy(grid.lowest_available_row_in_column(col))[1]
      open_spaces << [col, row] if row
    end

    open_spaces
  end

  def center_of_mass(color)
    positions = []

    (0..6).each do |col|
      (0..5).each do |row|
        spot = grid.xy_to_spot(col, row)
        positions << [col, row] if grid.occupied_spaces[spot] == color
      end
    end

    return [3, 2.5] if positions.empty?

    cx = 0.0
    cy = 0.0

    positions.each do |pos|
      cx += pos[0]
      cy += pos[1]
    end

    cx /= positions.size
    cy /= positions.size

    [cx, cy]
  end

  def num_in_columns
    (0..6).map do |col|
      [
        col,
        grid.spot_to_xy(grid.lowest_available_row_in_column(col))[1] # Y
      ]
    end.to_h
  end
end
