require_relative 'Player'

class RandomPlayer < Player

  attr_accessor :color, :opponent, :player_name

  def initialize(player_name)
    @color = 'navy'
    @opponent = nil
    @player_name = player_name
  end

  # make a random move from the columns available
  def play_round(grid)
    column = grid.available_columns[ rand(grid.available_columns.length) ]

    amount = rand( 1..grid.heaps[column] )

    return [column, amount]
  end

  
end
