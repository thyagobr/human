require 'board'

class Game < Gosu::Window
  attr_accessor :board

  def initialize
    @board = Board.new
    @width, @height = 800, 640
    super(@width, @height, fullscreen = false)
    self.caption = "human"
  end
  
end
