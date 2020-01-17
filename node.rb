class Node
  attr_accessor :grid, :column, :current_player, :we_win, :they_win, :children, :winning_children_count

  def initialize(grid, column, player_us, player_them, current_player, depth)
    # puts "new node!"
    @grid = grid
    @column = column
    @current_player = current_player
    @player_us = player_us
    @player_them = player_them
    @children = []
    @winning_children_count = 0
    @we_win = nil
    @they_win = nil
    @depth = depth

    # puts "play_self"
    play_self unless column.nil?

    if grid.winning_state?
      if current_player_is_us?
        we_win = true
      else
        they_win = true
      end
    end

    return if grid.winning_state? || grid.available_columns.empty?
    return if depth > 4
    calculate_children
  end

  def alternate_player
    if current_player_is_us?
      @player_them
    else
      @player_us
    end
  end

  def current_player_is_us?
    current_player.color == @player_us.color
  end

  def play_self
    grid.drop_in_column( current_player.color, column )
  end

  def calculate_children
    # puts 'calculating children...'

    grid_copy = Marshal.load( Marshal.dump(grid) )
    grid_copy.available_columns.each do |n|
      children << Node.new(grid_copy, n, @player_us, @player_them, alternate_player, @depth + 1)
    end

    winning_children = children.select { |c| c.we_win }
    @winning_children_count = winning_children.select do |c|
      x = c.we_win ? 1 : 0
      x + c.winning_children_count
    end.sum
  end
end

