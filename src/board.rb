require 'game'
require 'player'

class Board
  attr_accessor :tileset, :tiles_width, :tiles_height, :players

  def initialize(params = nil)
    @tiles_width = Game::DEFAULT_WIDTH / Game::DEFAULT_TILE_SIZE
    @tiles_height = Game::DEFAULT_HEIGHT / Game::DEFAULT_TILE_SIZE
    @tileset = Array.new(@tiles_width * @tiles_height)
    @players = Array.new
  end

  def fetch_by_coords(x, y)
    @tileset[(x / Game::DEFAULT_TILE_SIZE) * (y / Game::DEFAULT_TILE_SIZE)]
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
