class Player

  attr_accessor :color, :opponent

  def init
    @color = nil
    @opponent =  nil
  end

  # make a random move from the columns available
  def play_round(grid)
    fail 'NOT IMPLEMENTED'
  end
end
