require 'byebug'
require 'board'

class Game < Gosu::Window
  DEFAULT_WIDTH = 1280
  DEFAULT_HEIGHT = 768
  DEFAULT_TILE_SIZE = 64

  attr_accessor :board

  def initialize(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT, load_screen: true)
    @board = Board.new(tile: @tile)
    @width, @height = width, height
    if load_screen
      super(@width, @height, fullscreen = false)
      self.caption = "human"
      @board.add_player Player.new(window: self)
      @tile = Gosu::Image.new(self, "tileset_floor.png", true, (250 * 5) + 10, (250 * 2) + 10, 240, 240)
      @board.tile = @tile
    end
    @visibility = { fog: 3 }
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @board.player.left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @board.player.right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @board.player.up
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton1 then
      @board.player.down
    end
  end

  def draw
    # the Board gets to do the drawing... but, ok, by now
    (@height / DEFAULT_TILE_SIZE).times do |h|
      (@width / DEFAULT_TILE_SIZE).times do |w|
        #zero = (250 * 5) + 10
        #@tile = Gosu::Image.new(self, "tileset_floor.png", true, zero, zero, 240, 240)
        @board.draw_map(DEFAULT_TILE_SIZE * w, DEFAULT_TILE_SIZE * h, 0, 0.256, 0.256) if in_player_view(@board.player, w, h) 
      end
    end

    @board.render
  end

  def generate_level
    Array.new(((@width / DEFAULT_TILE_SIZE) * (@height / DEFAULT_TILE_SIZE)) * 2, 1)
  end

  def in_player_view(player, w, h)
    terrain_visibility = @visibility[:fog] * DEFAULT_TILE_SIZE
      (player.x - terrain_visibility) <= (DEFAULT_TILE_SIZE * w) and
      (player.x + terrain_visibility) >= (DEFAULT_TILE_SIZE * w) and
      (player.y - terrain_visibility) <= (DEFAULT_TILE_SIZE * h) and
      (player.y + terrain_visibility) >= (DEFAULT_TILE_SIZE * h)
  end


  def needs_cursor?; true; end

end
