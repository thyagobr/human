module Skill
  def skill(skill, difficulty, bounds = nil)
    case skill
    when :tree_cut then
      player_roll = Random.rand(1..20) + @tree_cut
      if player_roll >= difficulty
        tile = @board.fetch_by_coords(*bounds)
        unless tile.depleted?
          puts "you got 10 wood sticks [roll: #{player_roll}]"
          10.times { @inventory << Item.new(:wood) }
          tile.depleted = true
        end
      end
    when :make_fire then
      puts "rolling make_fire roll..."
      player_roll = Random.rand(1..20) + @make_fire
      puts "rolled a #{player_roll} against difficulty #{difficulty}"
      if player_roll >= difficulty
        wood_spent_per_try = 1
        index = @board.player.inventory.index { |item| item.type == :wood }
        if index
          item = @board.player.inventory.delete_at(index)
          coord_x = pos_x
          coord_y = pos_y
          case @facing
          when :up
            coord_y -= 32
          when :down
            coord_y += 32
          when :left
            coord_x -= 32
          when :right
            coord_x += 32
          end
          fire = Tile.new(@window, "fire.png", 0, 0, 64, 64, :fire)
          @board.set_by_coords(coord_x, coord_y, fire)
          puts "fire success!"
        else
          puts "you don't have wood!"
        end
      else
        puts "fire failed! you wasted one wood trying. you have #{@board.player.inventory.size} left"
      end
    end
  end
end
