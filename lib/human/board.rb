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
