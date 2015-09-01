require 'board'

class Game < Gosu::Window
  DEFAULT_WIDTH = 800
  DEFAULT_HEIGHT = 640
  DEFAULT_TILE_SIZE = 32

  attr_accessor :board

  def initialize(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT)
    @board = Board.new
    @width, @height = width, height
    super(@width, @height, fullscreen = false)
    @tile = Gosu::Image.new(self, "tileset_floor.png", true, (250 * 5) + 10, (250 * 2) + 10, 240, 240)
    self.caption = "human"
  end

  def update
      # logic
  end

  def draw
    (@height / 32).times do |h|
      (@width / 32).times do |w|
        @tile.draw(32 * w, 32 * h, 0, 0.13, 0.13)
      end
    end
  end

  def generate_level
    Array.new((@width / 32) * (@height / 32), 1)
  end

  def needs_cursor?; true; end
  
end
