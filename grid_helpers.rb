require_relative 'grid'

module GridHelpers
  # use this to determine available moves on the grid
  def available_columns
    x = 0

    results = @heaps.each_index.select{|i| @heaps[i] > 0}

    results
  end

  def render_player_moving(player)
    @error&.remove
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
    @error&.remove
    @player_moving&.remove
    @player_moving = Text.new(
      "Team #{@winner.player_name} has won the game!",
      x: 150, y: 0,
      size: 20,
      color: 'blue',
      z: 10
    )
  end

  def raise_illegal_move
    @error = Text.new(
      'ILLEGAL MOVE',
      x: 350, y: 0,
      size: 20,
      color: 'red',
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
    if column < 0
      raise_illegal_move
      first_available_move
    elsif @heaps[column] == 0
      raise_illegal_move
      first_available_move
    elsif @heaps[column] < amount
      raise_illegal_move
      [column, @heaps[column]]
    elsif amount <= 0
      puts 'third condition'
      raise_illegal_move
      [column, 1]
    else
      [column, amount]
    end
  end
end
