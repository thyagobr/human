class Player
  attr_accessor :x, :y, :poses

  def initialize(x: 0, y: 0, coords_system: :tiles, window: nil) 
    raise ArgumentError unless x or y
    @x, @y = [(Game::DEFAULT_WIDTH / 2) - 32, (Game::DEFAULT_HEIGHT / 2) - 32]
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
  def left; move(2); end
  def right; move(3); end

  def move(direction)
    case direction
    when 0
      @pos = 36
      @y -= @vel
    when 1
      @pos = 0
      @y += @vel
    when 2
      @pos = 12
      @x -= @vel
    when 3
      @pos = 24
      @x += @vel
    end 
    @anim = Gosu::milliseconds / 100 % 3
  end

end
