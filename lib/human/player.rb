class Player
  include Skill
  attr_accessor :x, :y, :poses, :inventory

  def initialize(x: 0, y: 0, coords_system: :tiles, window: nil, board: nil) 
    @board = board
    @inventory = []
    @x, @y = [(Main::SCREEN_X / 2) - 32, (Main::SCREEN_Y / 2) - 32]
    @tree_cut = 5
    @make_fire = 7
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
