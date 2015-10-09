require 'gosu'

class Main < Gosu::Window

	DEFAULT_WIDTH = 1280
	DEFAULT_HEIGHT = 720
	TILE_SIZE = 64

	def initialize
		super(1280, 720, fullscreen = false)
		@board = Board.new(self)
	end

	def draw
		@board.draw_map
	end
	def update; end

end

class Board

	attr_accessor :window

	def initialize(window)
		@window = window
		@dark_grass = Gosu::Image.new(@window, "hyptosis_tile-art-batch-1.png", true, 384, 0, 32, 32)
		@light_grass = Gosu::Image.new(@window, "hyptosis_tile-art-batch-1.png", true, 640, 0, 32, 32)
    @map = [
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
    ]
  end

  def draw_map
    render do |tile,coords|
      case tile
      when Tile::DARK_GRASS then
        @dark_grass.draw(coords[0] * Main::TILE_SIZE, coords[1] * Main::TILE_SIZE, 0, 2, 2)
      when Tile::LIGHT_GRASS then
        @light_grass.draw(coords[0] * Main::TILE_SIZE, coords[1] * Main::TILE_SIZE, 0, 2, 2)
      end
		end
	end
  
  private

	def render
		@map.each_with_index do |tile,index|
			yield tile, to_2d_coords(index)
		end
	end

	def to_2d_coords(index)
    # [x, y]
    # the x is the modulus of the index with the width
    # the y is the division of the index widh the width
    # so, where is index @map[42]?
    # x = 42 % (1720 / 32) = 42 % 40 = 2
    # y = 42 / (1720 / 32) = 42 / 40 = 1
    # so it's on the second line (y=1), third column (x=2)
    # (yes, it begins with 0)
		[(index % (Main::DEFAULT_WIDTH / Main::TILE_SIZE)), (index / (Main::DEFAULT_WIDTH / Main::TILE_SIZE))]
	end

	def fetch_coords(x, y)
		# x + y * width
		# but the width is in pixels, and we're moving in array positions
		# so, we have (Main::DEFAULT_WIDTH / Main::TILE_SIZE) array width
		@map[x + (y * (Main::DEFAULT_WIDTH / Main::TILE_SIZE))]
	end


end

class Tile
  DARK_GRASS = 0
  LIGHT_GRASS = 1
end

Main.new.show
