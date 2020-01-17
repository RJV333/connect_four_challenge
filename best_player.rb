require_relative 'Player'
require_relative 'node'

class BestPlayer < Player

  attr_accessor :color, :opponent, :grid

  def init
    @color = 'green'
  end

  def play_round(grid)
    @grid = grid

    return next_winning_move unless next_winning_move.nil?

    next_best_branch
  end

  def current_node
    other_player = Player.new
    other_player.color = opponent

    grid_copy = Marshal.load( Marshal.dump(grid) )
    Node.new(grid_copy, nil, self, other_player, self, 1)
  end

  def next_winning_move
    winning_games = current_node.children.select { |c| c.we_win }
    return nil if winning_games.empty?
    winning_games.first.column
  end

  def next_best_branch
    puts "next best branch"
    p current_node.children.sort_by { |c| c.winning_children_count }.map(&:winning_children_count)
    current_node.children.sort_by { |c| c.winning_children_count }.last.column
  end
end
