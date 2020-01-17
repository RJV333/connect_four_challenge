require 'ruby2d'
require_relative 'tile'
require_relative 'grid_helpers'

class Grid < Square
  include GridHelpers

  attr_accessor :tiles, :dots, :winner, :win_type, :last_occupied, :occupied_spaces, :columns_size
  attr_reader :grid_size, :x, :y, :tile_size, :margin

  def initialize()
    @tiles = []
    @columns_size = 7
    @row_count = 6
    @upper_bound = 7 * 6
    @x = 20
    @y = 400 #used to initialized layout, start low work up
    @tile_size = 70
    @margin = 2
    @occupied_spaces = {}
    @winner = nil
    draw_grid
  end

  def topped_column?(column_number)
    while column_number < @upper_bound
      if !@occupied_spaces.key?(column_number)
        return false
      end
      column_number += @columns_size
    end
    return true
  end
  # use this for your implementations
  def drop_in_column(color, col_number)
    spot_to_draw = lowest_available_row_in_column(col_number)

    add_to_occuped_spaces(spot_to_draw, color)
  end
  # for use in visualization
  def drop_and_draw_in_column(color, col_number)
    spot_to_draw = lowest_available_row_in_column(col_number)

    draw_dot(color, spot_to_draw)

    add_to_occuped_spaces(spot_to_draw, color)
  end

  def add_to_occuped_spaces(spot, color)
    @last_occupied = spot
    @occupied_spaces[spot] = color
  end

  def draw_grid
    y = @y
    @row_count.times do
      x = @x
      @columns_size.times do
        @tiles << Tile.new(
          x: x,
  	      y: y,
          size: @tile_size,
          color: 'navy'
        )
        x += @tile_size + @margin
      end
      y -= @tile_size + @margin
    end

    @tiles
  end

  def tile_center_position(tile)
    x = tile.x + (tile.size / 2)
    y = tile.y + (tile.size / 2)
    [x, y]
  end

  def draw_dot(color, position)
    instanciate_dot(@tiles[position], color)
  end

  def instanciate_dot(tile, color)
    points = tile_center_position(tile)
    points_x = points[0]
    points_y = points[1]
      tile.dot = Circle.new(
        x: points_x,
        y: points_y,
	      radius: 33,
        sectors: 32,
        color: color,
      )
  end

  def out_of_grid(event)
    @tiles.each do |tile|
      return false if tile.contains? event.x, event.y
      true
    end
  end

  def winning_state?
    vertical_win? || horizontal_win? || diagonal_win?
  end

  def vertical_win?
    x = 0

    while x < @columns_size
      return true if win_in_column?(x)
      x += 1
    end
  end

  def win_in_column?(column)
    streak = 0
    current_streak_color = nil
    iterator = column

    while iterator < @upper_bound do
      if !@occupied_spaces.key?(iterator)
        return false
      elsif @occupied_spaces[iterator] == current_streak_color
        streak += 1
        if streak >= 4
          @win_type = 'vertical'
          @winner = current_streak_color
          return true
        end
      else @occupied_spaces[iterator] != current_streak_color
        current_streak_color = @occupied_spaces[iterator]
        streak = 1
      end

      iterator += @columns_size
    end

    return false
  end

  def horizontal_win?
    y = 0

    while y < @row_count do
      return true if win_in_row?(y)
      y += 1
    end
  end

  def win_in_row?(row)
    streak = 0
    current_streak_color = nil
    iterator = row * @columns_size
    next_row = iterator + @columns_size

    while iterator < next_row do
      if !@occupied_spaces.key?(iterator)
        current_streak_color = nil
        streak = 0
      elsif @occupied_spaces[iterator] == current_streak_color
        streak += 1
        if streak >= 4
          @win_type = 'horizon'
          @winner = current_streak_color
          return true
        end
      else @occupied_spaces[iterator] != current_streak_color
        current_streak_color = @occupied_spaces[iterator]
        streak = 1
      end

      iterator += 1
    end

    return false
  end

  def diagonal_win?
    up_right_win? || down_right_win?
  end

  def up_right_win?
    start_points = [14, 7, 0, 1, 2, 3]

    start_points.each do |start|
      return true if up_right_4?(start)
    end

    false
  end

  def down_right_win?
    start_points = [35, 36, 37, 38, 28, 21]

    start_points.each do |start|
      return true if down_right_4?(start)
    end

    false
  end

  # is there a diagonal streak of 4 or more starting from spot number 'start'
  def up_right_4?(start)
    streak = 0
    current_streak_color = nil
    iterator = start

    while iterator < @upper_bound do
      # empty space, just pass through to see if streak begins on other side
      if !@occupied_spaces.key?(iterator)
        current_streak_color = nil
        streak = 0
      # ongoing streak, increment and check for CONNECT FOUR
      elsif @occupied_spaces[iterator] == current_streak_color
        streak += 1
        if streak >= 4
          @win_type = 'up_right_diag'
          @winner = current_streak_color
          return true
        end
      # edge case, wrapping around
      elsif @occupied_spaces[iterator] == current_streak_color && ( iterator % @columns_size == 0 )
        return
      #switch to other color to begin 'streak' from 1
      else @occupied_spaces[iterator] != current_streak_color
        current_streak_color = @occupied_spaces[iterator]
        streak = 1
      end

      iterator += (@columns_size + 1)
    end
  end

  # is there a diagonal streak of 4 or more starting from spot number 'start'
  def down_right_4?(start)
    streak = 0
    current_streak_color = nil
    iterator = start

    while iterator > 0 do
      # empty space, just pass through to see if streak begins on other side
      if !@occupied_spaces.key?(iterator)
        current_streak_color = nil
        streak = 0
      # ongoing streak, increment and check for CONNECT FOUR
      elsif @occupied_spaces[iterator] == current_streak_color && !( iterator % @columns_size == 0 )
        streak += 1
        if streak >= 4
          @win_type = 'down_right_diag'
          @winner = current_streak_color
          return true
        end
      # edge case, wrapping around
      elsif @occupied_spaces[iterator] == current_streak_color && ( iterator % @columns_size == 0 )
        return
      # switch to ther color, to begin 'streak' from one
      else @occupied_spaces[iterator] != current_streak_color
        current_streak_color = @occupied_spaces[iterator]
        streak = 1
      end

      iterator -= (@columns_size - 1)
    end
  end
end
