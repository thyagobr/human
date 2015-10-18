require 'gosu'
require 'byebug'

class Main < Gosu::Window

  SCREEN_X = 1280
  SCREEN_Y = 720
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

  def button_down(id)
    if id == Gosu::KbF
      if bounds = in_bounds?(@board.player, [:dead_tree_trunk_1])
        @board.player.skill(:tree_cut, 7, bounds)
      elsif bounds = in_bounds?(@board.player, [:dead_tree_trunk_0])
        @board.player.skill(:tree_cut, 7, bounds) 
      end
    end
  end

  def update
    if button_down? Gosu::KbQ
      puts "player_x: #{@board.player.x}, player_y: #{@board.player.y}"
      puts "fetch_by_coords: #{@board.fetch_by_coords(@board.player.x, @board.player.y)}"
      puts "#{@board.map_depleted}"
    end
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      # if the player x is above the middle of the screen, allow it to move back
      if @board.player.x > ((SCREEN_X / 2) - 32 - 1)
        @board.player.left(move: true)
      else
        # otherwise, update the player image, without moving it
        @board.player.left
        # if there's more room to move the camera to the left, move it
        if @board.camera.x >= 5 
          @board.camera.x -= 5
        else
          # if the camera is already at the left limit, move the player if it's not on wall too
          @board.player.left(move: true) if @board.camera.x <= 0 and @board.player.x > 0
        end
      end
      # in case of collision before player.x reaches 0?
      # better let the player's movement algorithm decide
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      # this means: player x must be lower than half the screen size minus half player size
      if @board.player.x < ((SCREEN_X / 2) - 32 - 1)
        @board.player.right(move: true)
      else
        #move_player = (@board.camera.x >= 0 (@board.map_x / TILE_SIZE)and @board.player.x > 0)
        #@board.camera.x >= (@board.map_x * TILE_SIZE)
        @board.player.right
        # this must be set to the maximum size of the board
        if @board.camera.x + SCREEN_X <= @board.map_x * TILE_SIZE
          @board.camera.x += 5
        else
          # move the player until he hits the wall
          @board.player.right(move: true) if @board.player.x <= SCREEN_X - 64
        end
      end
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      if @board.player.y > ((SCREEN_Y / 2) - 32 - 1)
        @board.player.up(move: true)
      else
        @board.player.up
        if @board.camera.y >= 5 
          @board.camera.y -= 5
        else
          @board.player.up(move: true) if @board.camera.y <= 0 and @board.player.y > 0
        end
      end
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      if @board.player.y < ((SCREEN_Y / 2) - 32 - 1)
        @board.player.down(move: true)
      else
        @board.player.down
        if @board.camera.y + SCREEN_Y <= @board.map_y * TILE_SIZE
          @board.camera.y += 5
        else
          @board.player.down(move: true) if @board.player.y <= SCREEN_Y - 64
        end
      end
    end
  end

  def in_bounds?(player, entities)
    @board.check_bounds(player, entities)
  end

end

class Board

  attr_accessor :window, :camera, :player, :map_depleted

  def initialize(window)
    @camera = Camera.new(0, 0)
    @window = window
    @player = Player.new(window: window, board: self)
    @dark_grass = Tile.new(@window, "hyptosis_tile-art-batch-1.png", 384, 0, 32, 32, :dark_grass)
    @light_grass = Tile.new(@window, "hyptosis_tile-art-batch-1.png", 640, 0, 32, 32, :light_grass)
    @dead_tree_trunk_0 = Tile.new(@window, "hyptosis_tile-art-batch-1.png", 448, 224, 32, 32, :dead_tree_trunk_0)
    @dead_tree_trunk_1 = Tile.new(@window, "hyptosis_tile-art-batch-1.png", 448, 192, 32, 32, :dead_tree_trunk_1)
    # its @map[y][x] - first we get the rows, which correspond to y; then, the units along the x
    @map_sketch = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    ]
    @map = @map_sketch.map do |row|
      row.map do |int|
        instance_variable_get("@#{Tile::TILES[int]}").dup
      end
    end
  end

  def draw_map
    render do |tile, x, y|
      # default ground
      @dark_grass.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y)
      tile.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y) if not tile.depleted?
      #      case tile
      #      when Tile::LIGHT_GRASS then
      #        @light_grass.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y)
      #      when Tile::DEAD_TREE_TRUNK_0 then
      #        unless resource_depleted?(tile, x, y)
      #          @dead_tree_trunk_0.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y)
      #        end
      #      when Tile::DEAD_TREE_TRUNK_1 then
      #        @dead_tree_trunk_1.draw(x * Main::TILE_SIZE - @camera.x, y * Main::TILE_SIZE - @camera.y)
      #      end
    end
  end

  # this will be a method belonging to future Map class
  def map_dimensions
    # [width, height], in array-size
    [@map[0].size, @map.size]
  end
  def map_x; map_dimensions[0]; end
  def map_y; map_dimensions[1]; end

  # ToDo: sort out this x, y -> y, x mess
  def fetch_by_coords(x, y)
    @map[((y + @camera.y) / Main::TILE_SIZE)][((x + @camera.x) / Main::TILE_SIZE)]
  end

  def check_bounds(player, entities)
    positions_matrix = [
      [player.x, player.y],
      [player.x + Main::TILE_SIZE, player.y],
      [player.x - Main::TILE_SIZE, player.y],
      [player.x, player.y + Main::TILE_SIZE],
      [player.x, player.y - Main::TILE_SIZE],
    ]

    positions_matrix.each do |pos|
      if fetch_by_coords(*pos).type == entities.first
        return pos
      end
    end

    false
  end

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

  def resource_depleted?(tile, x, y)
    @map_depleted[y] and @map_depleted[y][x] and @map_depleted[y][x].include?(tile)
  end

  def in_camera_view(x, y)
    (@camera.x + (Main::SCREEN_X / Main::TILE_SIZE) <= x) and
      (@camera.y + (Main::SCREEN_X / Main::TILE_SIZE) <= y)
  end

end

class Tile
  DARK_GRASS = 0
  LIGHT_GRASS = 1
  DEAD_TREE_TRUNK_1 = 2
  DEAD_TREE_TRUNK_0 = 3

  TILES = {
    0 => :dark_grass,
    1 => :light_grass,
    3 => :dead_tree_trunk_0,
    2 => :dead_tree_trunk_1
  }

  attr_accessor :image, :depleted, :type

  def initialize(window, image_name, x, y, w, h, type)
    @type = type
    @depleted = false
    @image = Gosu::Image.new(window, image_name, true, x, y, w, h)
  end

  def depleted?; @depleted; end

  def draw(x, y)
    @image.draw(x, y, 0, 2, 2)
  end

end

class Camera
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end
end

module Skill
  def skill(skill, difficulty, bounds)
    case skill
    when :tree_cut then
      player_roll = Random.rand(1..20) + @tree_cut
      if player_roll >= difficulty
        tile = @board.fetch_by_coords(*bounds)
        unless tile.depleted?
          puts "you got 10 wood sticks [roll: #{player_roll}]"
          tile.depleted = true
        end
      end
    end
  end
end

class Player
  include Skill
  attr_accessor :x, :y, :poses

  def initialize(x: 0, y: 0, coords_system: :tiles, window: nil, board: nil) 
    @board = board
    @x, @y = [(Main::SCREEN_X / 2) - 32, (Main::SCREEN_Y / 2) - 32]
    @tree_cut = 5
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

  def up(move: false); move(0, move: move); end
  def down(move: false); move(1, move: move); end
  def left(move: false); move(2, move: move); end
  def right(move: false); move(3, move: move); end

  def move(direction, move: false)
    case direction
    when 0
      @pos = 36
      @y -= @vel if move
    when 1
      @pos = 0
      @y += @vel if move
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
