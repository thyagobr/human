class Player
  attr_accessor :x, :y

  def initialize(x: 0, y: 0, coords_system: :tiles)
    raise ArgumentError unless x or y
    @x, @y = x, y
  end

  def pos
    [@x, @y]
  end

end
