require_relative 'Player'

class RandomPlayer < Player

  attr_accessor :color, :opponent, :player_name

  def initialize(player_name)
    @color = 'navy'
    @opponent = nil
    @player_name = player_name
  end

  # make a random move from the columns available
  def play_round(heaps)
    column = available_columns(heaps)[ rand(available_columns(heaps).length) ]

    amount = rand( 1..heaps[column] )

    return [column, amount]
  end

  # returns and array of ints representing avail columns
  def available_columns(heaps)
    x = 0

    results = heaps.each_index.select{|i| heaps[i] > 0}

    results
  end
end
