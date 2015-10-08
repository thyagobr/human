require 'game'
require 'player'

class Board
  attr_accessor :tileset, :tiles_width, :tiles_height, :players, :tile, :pos_x, :pos_y

  def initialize(params = nil)
    @tiles_width = Game::DEFAULT_WIDTH / Game::DEFAULT_TILE_SIZE
    @tiles_height = Game::DEFAULT_HEIGHT / Game::DEFAULT_TILE_SIZE
    @tileset = load_map("rainforest.map")
    @players = Array.new
    @pos_x = 1
    @pos_y = 0
  end

  def fetch_by_coords(x, y)
    #@tileset[(x / Game::DEFAULT_TILE_SIZE) * (y / Game::DEFAULT_TILE_SIZE)]
    local_x = (x / Game::DEFAULT_TILE_SIZE) + @pos_x
    local_y = (y / Game::DEFAULT_TILE_SIZE) + @pos_y
    # 3 times here, 'cuz I set the map to be 3 * DEFAULT_WIDTH manually on irb
    @tileset[local_x + (local_y * ((3 * Game::DEFAULT_WIDTH) / Game::DEFAULT_TILE_SIZE))]
  end

  def add_player(player)
    @players << player
  end

  def player
    @players.first
  end

  def render
    @players.first.draw if @players.first
  end

  def load_map(file)
    Marshal.load File.read(file)
  end

  def draw_map(x, y, z, scale_x, scale_y)
    case fetch_by_coords(x, y)
    when 1 then @tile.draw(x, y, 0, 0.256, 0.256)
    when 2 then 
    end
  end

end

class Tile
  # may contain many sprites for transparency composition
end
