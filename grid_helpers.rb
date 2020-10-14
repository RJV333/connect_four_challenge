require_relative 'grid'

module GridHelpers
  # use this to determine available moves on the grid
  def available_columns
    x = 0

    results = @heaps.each_index.select{|i| @heaps[i] > 0}

    results
  end

  def render_player_moving(player)
    @player_moving&.remove
    @player_moving = Text.new(
      player.player_name,
      x: 150, y: 0,
      size: 20,
      color: 'blue',
      z: 10
    )
  end

  def render_game_winner
    @player_moving&.remove
    @player_moving = Text.new(
      "Team #{@winner.player_name} has won the game!",
      x: 150, y: 0,
      size: 20,
      color: 'blue',
      z: 10
    )
  end

  def set_winner(player)
    if @winner.nil?
      @winner = player
    end
  end

  def first_available_move
    [available_columns[0], 1]
  end

  def mold_column_amount_for_bad_info(column, amount)
    if @heaps[column] == 0
      first_available_move
    elsif @heaps[column] < amount
      [column, @heaps[column]]
    elsif amount <= 0
      [column, 1]
    else
      [column, amount]
    end
  end
end
