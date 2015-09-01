require 'game'
require 'player'

class Board
  TILE_SIZE = 32

  attr_accessor :tileset, :tiles_width, :tiles_height, :players

  def initialize(params = nil)
    @tiles_width = 800 / TILE_SIZE
    @tiles_height = 600 / TILE_SIZE
    @tileset = Array.new(@tiles_width * @tiles_height)
    @players = Array.new
  end

  def fetch_by_coords(x, y)
    @tileset[(x / TILE_SIZE) * (y / TILE_SIZE)]
  end

  def add_player(player)
    @players << player
  end

end

class Tile
  # may contain many sprites for transparency composition
end

class Player

end
