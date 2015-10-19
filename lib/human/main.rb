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
    case id
    when Gosu::KbC
      if bounds = in_bounds?(@board.player, [:dead_tree_trunk_1])
        @board.player.skill(:tree_cut, 7, bounds)
      elsif bounds = in_bounds?(@board.player, [:dead_tree_trunk_0])
        @board.player.skill(:tree_cut, 7, bounds) 
      end
    when Gosu::KbF
      @board.player.skill(:make_fire, 15)
    when Gosu::KbT
      @board.player.warp(Random.rand(0..1280), Random.rand(0..720))
    end
  end

  def update
    if button_down? Gosu::KbQ
      puts "player_x: #{@board.player.x}, player_y: #{@board.player.y}"
      puts "fetch_by_coords: #{@board.fetch_by_coords(@board.player.x, @board.player.y)}"
      byebug
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
