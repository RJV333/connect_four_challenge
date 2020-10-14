class Player

  attr_accessor :color, :opponent

  def initialize(player_name)
    @player_name = player_name
  end

  # heaps: 7 element array of integers with values 0 - 6, representing board

  # returns two integers: [column_index, disc_removal_amount]
  def play_round(heaps)
    fail 'NOT IMPLEMENTED'
  end
end
