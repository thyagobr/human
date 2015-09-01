class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end
  
end

class Board
  TILE_SIZE = 32

  attr_accessor :tileset, :tiles_width, :tiles_height

  def initialize(params = nil)
    @tiles_width = 800 / TILE_SIZE
    @tiles_height = 600 / TILE_SIZE
    @tileset = Array.new(@tiles_width * @tiles_height)
  end

  def fetch_by_coords(x, y)
    @tileset[(x / TILE_SIZE) * (y / TILE_SIZE)]
  end

end

class Tile
  # may contain many sprites for transparency composition
end
