require 'forwardable'

module LD20
  class PlayerSprite < Chingu::GameObject
    extend Forwardable
    def_delegators(:@basic_player, 
        :health, :health=, :max_health, :max_health=,
        :coins, :coins=, :keys, :get_key, :has_key?, :consume_key,
        :damage_taken, :die, :dead?, :deciphered,
        :get_item, :has_item?, :each_item
        )
    
    attr_reader :last_x, :last_y, :moving
    traits :bounding_box, :collision_detection, :timer
    include TerrainCollision
    
    def initialize(options = {})
      @basic_player = options[:basic_player]
      super
    end
    
    def setup
      self.input = {
        :holding_left  => :move_west, 
        :holding_right => :move_east, 
        :holding_up    => :move_north, 
        :holding_down  => :move_south,
        :z             => :sword,
        :x             => :activate_item,
        :p             => :pry
      }
        
      
      
      
      @animations = Chingu::Animation.new(file: "player_32x32.png", delay: 250)
      @animations.frame_names = {
        facing_south: 0..0,
        moving_south: 0..3, 
        facing_north: 4..4,
        moving_north: 4..7,
        facing_west:  8..8,
        moving_west:  8..11,
        facing_east: 12..12,
        moving_east: 12..15
      }
      @frame_name = :facing_south
      @facing = :south
          
      @last_x, @last_y = @x, @y
      
      update
      cache_bounding_box
    end
    
    def move_west
      @moving = @facing = :west
      @frame_name = :moving_west
    end
    
    def move_east
      @moving = @facing = :east
      @frame_name = :moving_east
    end
    
    def move_north
      @moving = @facing = :north
      @frame_name = :moving_north
    end
    
    def move_south
      @moving = @facing = :south
      @frame_name = :moving_south
    end
    
    def sword
      if PlayerSword.size.zero?
        PlayerSword.create(:x => @x, :y => @y, :direction => @facing )
      end
    end
    
    def activate_item
      if has_item?(:lipstick) && KissHeart.size.zero?
        KissHeart.create(x: @x, y: @y, direction: @facing)
      end
    end
    
    
    def hit_by(enemy)
      return if @invincible
      self.health -= 1
      return if dead?
      #Sound["player_ouch.ogg"].play
      flinch
      during(500) {
        @invincible = true
        self.mode = :additive
      }.then {
        @invincible = false
        self.mode = :default
      }
    end
    
    def flinch
      @flinching = true
      @parent.remove_input_client(self)
      during(50) {
        @moving = case @facing
        when :north then :south
        when :south then :north
        when :east then :west
        when :west then :east
        end
      }.then {
        @flinching = false
        @parent.add_input_client(self)
      }
    end
    
    def undo_move
      @x, @y = @last_x, @last_y
    end
    

    def update
      @frame_name = :"facing_#{@facing}" unless @moving
      @image = @animations[@frame_name].next
      return unless PlayerSword.size.zero?
      
      move = case @moving
      when :west  then [-2, 0]
      when :east  then [ 2, 0]
      when :north then [ 0,-2]
      when :south then [ 0, 2]
      else [0,0]
      end
      
      move.map! {|m| m * 4} if @flinching
      @x += move[0]; @y += move[1]
      
      travel(@moving) if @moving
      
      
    end
    
    def travel(direction)
      if leaving_screen?
        @parent.transition(direction)
      else
        check_movement(direction)
      end
    end
    
    def check_movement(dir)
      bb = self.bounding_box
      case dir
      when :north
        b = bias(@x)
        corners = [bb.topleft, bb.topright]
      when :south
        b = bias(@x)
        corners = [bb.bottomleft, bb.bottomright]
      when :east
        b = bias(@y)
        corners = [bb.topright, bb.bottomright]
      when :west
        b = bias(@y)
        corners = [bb.topleft, bb.bottomleft]
      end

      corners.reverse! if b > 0

      if blocked_at?(*corners[0])
        puts "primary blocked"
        undo_move
      elsif b.nonzero? and secondary_blocked_at?(*corners[1])
        puts "secondary blocked"
        undo_move
        adjust(b,dir)
      else
        #continue
      end

    end
    
    def blocked_at?(x,y)
      return true if @parent.terrain_at(x,y).impassible_for_player?
      ImpassibleProp.each_at(x,y) do |_|
        return true
      end
      ClosedDoor.each_at(x,y) do |_|
        return true
      end
      false
    end
    
    # Pushable blocks cannot be pushed if you are too terribly off-center.
    def secondary_blocked_at?(x,y)
      return true if blocked_at?(x,y)
      PushableProp.each_at(x,y) do |_|
        return true
      end
      false
    end

    def adjust(b,dir)
      if b.abs <= 8
        case dir
        when :north, :south
          @x += (b <=> 0) * 2
        else
          @y += (b <=> 0) * 2
        end
      end
    end

    # We want a bias that points back towards the center of the tile. So, if smaller than 16, positive bias.
    # If larger than 16, negative bias.
    def bias(offset)
      16 - (offset % 32)
    end
    
    #leaving in, but trying something else.
    def old_update
      @frame_name = :"facing_#{@facing}" unless @moving
      @image = @animations[@frame_name].next
      return unless PlayerSword.size.zero?
      
      #TODO: Make it so that grid correction still applies as you walk into a wall.
      move = case @moving
      when :west  then [-2, correction_y]
      when :east  then [ 2, correction_y]
      when :north then [ correction_x,-2]
      when :south then [ correction_x, 2]
      else [0,0]
      end
      
      move.map! {|m| m * 4} if @flinching
      
      @x += move[0]; @y += move[1]
      
      
      #TODO: Do collision checks for player during this movement phase, rather than room.update.
      if @moving
        if leaving_screen?
          @parent.transition(@moving)
        elsif colliding_with_terrain?(@moving)
          undo_move
        else
          stop = false
          each_bounding_box_collision(ClosedDoor) do |player, door|
            stop = ((door.parent == $window.current_game_state) && door.player_collision(player))
          end
          if stop
            @x, @y = @last_x, @last_y
          end
        end
      end
    end
    
    # These are applied to correct movement along a half-tile grid
    # see http://troygilbert.com/2006/10/the-movement-and-attack-mechanics-of-the-legend-of-zelda/
    def correction_x
      -(((@x + 8) % 16) <=> 8)
    end
    
    def correction_y
      -(((@y + 8) % 16) <=> 8)
    end
    
    
    def end_of_tick
      @moving = nil
      @undo_move = false
      @last_x, @last_y = @x, @y
    end
    

  end
end