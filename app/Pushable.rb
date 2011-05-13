module LD20
  class Prop::Pushable < Prop
    trait :bounding_box, :scale => 1.0
    
    def build(properties = {})
      @properties = properties
      if puzzle_pos = @options[:puzzle_pos]
        @puzzle = true
        @puzzle_x, @puzzle_y = puzzle_pos
      end
      @image = Image['wall.png']
      @being_pushed_in_direction = nil
      @push_time = 0
      @moving = nil
      @move_distance = 0
      @moved = false
    end
    
    def puzzle_pos
      [@puzzle_x, @puzzle_y]
    end
    
    def player_collision(player)
      return if @moving
      player.undo_move
      @push_time = 0 unless @being_pushed_in_direction == player.moving
      @being_pushed_in_direction = player.moving
      @push_time += 1 #TODO: Make based on time rather than frames.
      if @push_time >= 60
        return if will_collide?
        @moving = @being_pushed_in_direction
        @being_pushed_in_direction = nil
        @push_time = 0
        @move_distance = 0
      end
    end
    
    def will_collide?
      delta = dir_delta(@being_pushed_in_direction)
      sx = @x + TileWidth * delta[0]
      sy = @y + TileWidth * delta[1]
      return true unless @parent.terrain_at(sx,sy).walkable
      Prop.each_at(sx,sy) do |prop|
        return true
      end
      return false
    end
    
    def update
      if @moving
        @move_distance += 2
        move = dir_delta(@moving)
        if @move_distance > TileWidth # TODO: make check based on width or height depending on move direction... maybe.
          @moving = nil
          @move_distance = 0
          @moved = true
          @puzzle_x += move[0]; @puzzle_y += move[1]
          @parent.check_puzzle_prize
        else
          @x += 2 * move[0]; @y += 2 * move[1]
        end
      end
    end
    
    def dir_delta(dir)
      case dir
      when :west  then [-1, 0]
      when :east  then [ 1, 0]
      when :north then [ 0,-1]
      when :south then [ 0, 1]
      else; [0,0]
      end
    end
    
  end
end