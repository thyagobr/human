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
      player_roll = Random.rand(1..20) + @make_fire
      if player_roll >= difficulty
        wood_spent_per_try = 1
        if item = @board.player.inventory.any? { |item| item.type == :wood }
          # think this through...
        end
      end
    end
  end
end
