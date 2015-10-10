require 'gosu'
require 'byebug'

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

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
     #@board.player.left
      @board.camera.x -= 5 unless @board.camera.x <= 0
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
     #@board.player.right
      @board.camera.x += 5 #unless @board.camera.x >= (DEFAULT_WIDTH / TILE_SIZE)
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
     #@board.player.up
      @board.camera.y -= 5 unless @board.camera.y <= 0
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
     #@board.player.down
      @board.camera.y += 5 #unless @board.camera.y >= (DEFAULT_HEIGHT / TILE_SIZE)
    end
  end

end

class Board

	attr_accessor :window, :camera

	def initialize(window)
    @camera = Camera.new(0, 0)
		@window = window
		@dark_grass = Gosu::Image.new(@window, "hyptosis_tile-art-batch-1.png", true, 384, 0, 32, 32)
		@light_grass = Gosu::Image.new(@window, "hyptosis_tile-art-batch-1.png", true, 640, 0, 32, 32)
    @map = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    ]
  end

  def draw_map
    render do |tile, x, y|
      case tile
      when Tile::DARK_GRASS then
        @dark_grass.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y, 0, 2, 2)
      when Tile::LIGHT_GRASS then
        @light_grass.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y, 0, 2, 2)
      end
		end
	end
  
  private

	def render
    @width = @map[0].size
    @height = @map.size

    @map.each_with_index do |row,y|
      row.each_with_index do |tile,x|
        yield tile, x, y
      end
    end

#		@map.each_with_index do |tile,index|
#      x, y = to_2d_coords(index)
#      yield tile, x, y if in_camera_view(x, y)
#		end
	end

  def in_camera_view(x, y)
    (@camera.x + (Main::DEFAULT_WIDTH / Main::TILE_SIZE) <= x) and
      (@camera.y + (Main::DEFAULT_WIDTH / Main::TILE_SIZE) <= y)
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

class Camera
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end
end

Main.new.show
