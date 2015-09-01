require 'board'

class Game < Gosu::Window
  DEFAULT_WIDTH = 1280
  DEFAULT_HEIGHT = 768
  DEFAULT_TILE_SIZE = 64

  attr_accessor :board

  def initialize(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT, load_screen: true)
    @board = Board.new
    @width, @height = width, height
    if load_screen
      super(@width, @height, fullscreen = false)
      @tile = Gosu::Image.new(self, "tileset_floor.png", true, (250 * 5) + 10, (250 * 2) + 10, 240, 240)
      self.caption = "human"
    end
  end

  def update
      # logic
  end

  def draw
    (@height / DEFAULT_TILE_SIZE).times do |h|
      (@width / DEFAULT_TILE_SIZE).times do |w|
        @tile.draw(DEFAULT_TILE_SIZE * w, DEFAULT_TILE_SIZE * h, 0, 0.256, 0.256)
      end
    end
  end

  def generate_level
    Array.new((@width / DEFAULT_TILE_SIZE) * (@height / DEFAULT_TILE_SIZE), 1)
  end

  def needs_cursor?; true; end
  
end
