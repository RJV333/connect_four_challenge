require 'ruby2d'
require 'byebug'
require_relative 'random_player'
require_relative 'intermediate_player'
require_relative 'grid'

set title: 'Connect Four Game Player', background: 'white'

g = Grid.new

tick = 0
time_increment = 120
column = 0

p1 = RandomPlayer.new
p2 = EasyPlayer.new
p1.color = 'red'
p2.color = 'olive'
p1.opponent = p2.color
p2.opponent = p1.color


update do
  if tick % time_increment == 0
    column = rand(7)
    next if !g.available_columns.include?(column)

    if tick % (time_increment * 2) == 0
      player = p1
    else
      player = p2
    end
    byebug if player == p2
    if g.winning_state?
      set title: "Winner!: #{g.winner}"
    else
      grid_copy = Marshal.load( Marshal.dump(g) ) # deep copy
      g.drop_and_draw_in_column( player.color, player.play_round(grid_copy) )
    end
  end

  tick += 1
end

show