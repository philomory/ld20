if moving? and entering_new_square?
  if terrain_being_entered.any? {|square| square is impassible for me? }
    reset_to_previous_position
  elsif in_control_of_own_movement? && !(center_terrain is safe for me?) && terrain_being_entered.any? {|square| square is dangerous for me? }
    entering_dangerous_terrain # for player, slow down and play warning sound; for enemy, reset_to_previous_position
  end
end
trigger_terrain_effect


correcting_coordinate = cas

def check_movement(dir)
  bb = self.bounding_box
  case dir
  when :north
    b = bias(@x)
    corners = [bb.topleft, bb.topright]
  when :south
    b = bias(@x)
    corners = [bb.bottomleft, bb.bottomroght]
  when :east
    b = bias(@y)
    corners = [bb.topright, bb.bottomright]
  when :west
    b = bias(@y)
    corners = [bb.topleft, bb.bottomleft]
  end
  
  corners.reverse! if b > 0
  
  if blocked_at?(*corners[0])
    stop
  elsif blocked_at?(*corners[1])
    stop
    adjust(b,dir)
  else
    continue
  end
  
end

def blocked_at?(x,y)
  return true if @parent.terrain_at(x,y).impassible_for_player?
  ImpassibleProps.each_at(x,y) do |_|
    return true
  end
  false
end

def adjust(b,dir)
  if b.abs < 3
    case dir
    when :north, :south
      @x += b
    else
      @y += b
    end
  end
end

# We want a bias that points back towards the center of the tile. So, if smaller than 16, positive bias.
# If larger than 16, negative bias.
def bias(offset)
  16 - (offset % 32)
end