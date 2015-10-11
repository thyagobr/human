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

  def width
    @board.map
  end

	def draw
		@board.draw_map
	end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      # in case of collision before player.x reaches 0?
      # better let the player's movement algorithm decide
      move_player = (@board.camera.x <= 0 and @board.player.x > 0)
      @board.player.left(move: move_player)
      @board.camera.x -= 5 unless @board.camera.x <= 0
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      # this means: player x must be lower than half the screen size minus half player size
      if @board.player.x < ((DEFAULT_WIDTH / 2) - 32)
        @board.player.right(move: true)
      else
        #move_player = (@board.camera.x >= 0 (@board.map_x / TILE_SIZE)and @board.player.x > 0)
        @board.player.right
        # this must be set to the maximum size of the board
        @board.camera.x += 5 unless @board.camera.x >= @board.map_x * TILE_SIZE
      end
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @board.player.up
      @board.camera.y -= 5 unless @board.camera.y <= 0
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      @board.player.down
      @board.camera.y += 5 #unless @board.camera.y >= (DEFAULT_HEIGHT / TILE_SIZE)
    end
  end

end

class Board

	attr_accessor :window, :camera, :player

	def initialize(window)
    @camera = Camera.new(0, 0)
		@window = window
    @player = Player.new(window: window)
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

  # this will be a method belonging to future Map class
  def map_dimensions
    # [width, height], in array-size
    [@map[0].size, @map.size]
  end
  def map_x; map_dimensions[0]; end
  def map_y; map_dimensions[1]; end
  
  private

	def render
    @width, @height = map_dimensions

    @map.each_with_index do |row,y|
      row.each_with_index do |tile,x|
        yield tile, x, y
      end
    end

    @player.draw

	end

  def in_camera_view(x, y)
    (@camera.x + (Main::DEFAULT_WIDTH / Main::TILE_SIZE) <= x) and
      (@camera.y + (Main::DEFAULT_WIDTH / Main::TILE_SIZE) <= y)
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

class Player
  attr_accessor :x, :y, :poses

  def initialize(x: 0, y: 0, coords_system: :tiles, window: nil) 
    @x, @y = [(Main::DEFAULT_WIDTH / 2) - 32, (Main::DEFAULT_HEIGHT / 2) - 32]
    @vel = 3
    @pos = 0
    @anim = 0
    @score = 0
    if window
      @window = window
      @poses = Gosu::Image.load_tiles(window, "crisiscorepeeps.png", 32, 32, true)
    end
  end

  def pos
    [@x, @y]
  end

  def draw
    @poses[@pos + @anim].draw(@x, @y, 1, 1.5, 1.5)
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def pos_x; @x + 64; end
  def pos_y; @y + 64; end

  def up; move(0); end
  def down; move(1); end
  def left(move: false); move(2, move: move); end
  def right(move: false); move(3, move: move); end

  def move(direction, move: false)
    case direction
    when 0
      @pos = 36
      #@y -= @vel
    when 1
      @pos = 0
      #@y += @vel
    when 2
      @pos = 12
      @x -= @vel if move
    when 3
      @pos = 24
      @x += @vel if move
    end 
    @anim = Gosu::milliseconds / 100 % 3
  end

end

Main.new.show
