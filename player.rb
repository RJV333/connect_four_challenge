class Player

  attr_accessor :color, :opponent

  def initialize(player_name)
    @color = nil
    @opponent =  nil
    @player_name = player_name
  end

  # make a random move from the columns available
  def play_round(grid)
    fail 'NOT IMPLEMENTED'
  end
end
