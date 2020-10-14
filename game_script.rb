require 'ruby2d'
require 'byebug'
require_relative 'random_player'
require_relative 'grid'

set title: 'Matches', background: 'white'

g = Grid.new

tick = 0 # set timer to 0
time_increment = 120 # approx 2 seconds per move

p1 = RandomPlayer.new("First")
p2 = RandomPlayer.new("Second")

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
  if tick % time_increment == 0

    if tick % (time_increment * 2) == 0
      player = player_one
    else
      player = player_two
    end

    if g.winning_state?
      set title: "Winner!: #{player.player_name}"
    else
      set title: "Player: #{player.player_name}"
      column, amount = player.play_round(g.heaps)
      #skip players turn if they give invalid column
      next if !g.available_columns.include?(column)

      g.remove_chips_from_heap( column, amount )
    end
  end

  tick += 1
end

show
