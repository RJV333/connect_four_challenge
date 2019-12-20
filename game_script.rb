require 'ruby2d'
require 'byebug'
require_relative 'random_player'
require_relative 'easy_player'
require_relative 'better_player'
require_relative 'grid'

set title: 'Connect Four Game Player', background: 'white'

g = Grid.new

tick = 0 # set timer to 0
move_time_increment = 60 # approx 2 seconds per move

p1 = BetterPlayer.new
p2 = BetterPlayer.new
p1.color = 'fuchsia'
p2.color = 'green'
p1.opponent = p2.color
p2.opponent = p1.color

#simulated coin toss for first move
coin_toss = rand(2)

if coin_toss == 1
  player_one = p1
  player_two = p2
else
  player_one = p2
  player_two = p1
end


update do
  if tick % move_time_increment == 0


    if tick % (move_time_increment * 2) == 0
      player = player_one
    else
      player = player_two
    end

    if g.winning_state?
      set title: "Winner!: #{g.winner}"
    else
      grid_copy = Marshal.load( Marshal.dump(g) ) # deep copy

      column =  player.play_round(grid_copy)
      #skip players turn if they give invalid column
      next if !g.available_columns.include?(column)

      g.drop_and_draw_in_column( player.color, column )
    end
  end

  tick += 1
end

show
