require_relative 'Player'

class EasyPlayer < Player

  attr_accessor :color, :opponent

  def initialize
    @color = 'green'
  end

  # make a random move from the columns available
  def play_round(grid)
    return 3 if grid.open_space?(3)

    grid.available_columns.each do | col |
      if grid.is_winning_move_for?(@color, col)
        return col
      end
    end

    grid.available_columns[ rand(grid.available_columns.length) ]
  end
end
