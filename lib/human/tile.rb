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
