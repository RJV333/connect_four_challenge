require_relative 'Player'

class RandomPlayer < Player

  attr_accessor :color, :opponent

  def init
    @color = 'navy'
    @opponent = nil
  end

  # make a random move from the columns available
  def play_round(grid)
    grid.available_columns[ rand(grid.available_columns.length) ]
  end
end
