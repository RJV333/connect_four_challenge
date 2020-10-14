require 'ruby2d'
require_relative 'tile'
require_relative 'grid_helpers'

class Grid < Square
  include GridHelpers

  attr_accessor :tiles, :dots, :winner, :win_type, :last_occupied, :occupied_spaces, :columns_size, :heaps
  attr_reader :grid_size, :x, :y, :tile_size, :margin

  def initialize()
    @tiles = []
    @heaps = [6, 6, 6, 6, 6, 6, 6]
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

  def update_heaps(column, amount)
    heaps[column] -= amount
  end

  def column_height(column)
    @heaps[column] - 1
  end

  def remove_chips_from_heap(column, amount)
    removal_position = column + column_height(column) * @columns_size

    amount.times do
      remove_chip(removal_position)
      removal_position = removal_position - @columns_size
    end

    update_heaps(column, amount)
  end

  def remove_chip(position)
    # replace red dot with one matching background
    draw_dot('navy', position)
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

    @tiles.each_with_index do |tile, index|
      draw_dot('red', index)
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

  def winning_state?
    @heaps == [0, 0, 0, 0, 0, 0, 0]
  end
end
