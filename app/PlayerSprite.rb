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
    
    attr_reader :last_x, :last_y
    trait :bounding_box, :scale => 0.6
    traits :collision_detection, :timer
    include TerrainCollision
    
    def initialize(options = {})
      super
      @basic_player = options[:basic_player]
    end
    
    def setup
      self.input = {
        :holding_left  => :move_west, 
        :holding_right => :move_east, 
        :holding_up    => :move_north, 
        :holding_down  => :move_south,
        :z             => :sword
      }
        
      
      @animation = Chingu::Animation.new(:file => "player_32x32.png")
      @animation.frame_names = {:facing_north => 0, :facing_south => 1, :facing_west => 2, :facing_east => 3 }
      @frame_name = :facing_south
      @facing = :south
          
      @last_x, @last_y = @x, @y
      update
    end
    
    def move_west
      @moving = @facing = :west
      @frame_name = :facing_west
    end
    
    def move_east
      @moving = @facing = :east
      @frame_name = :facing_east
    end
    
    def move_north
      @moving = @facing = :north
      @frame_name = :facing_north
    end
    
    def move_south
      @moving = @facing = :south
      @frame_name = :facing_south
    end
    
    def sword
      if PlayerSword.size.zero?
        PlayerSword.create(:x => @x, :y => @y, :direction => @facing )
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
      @undo_move = true
    end
    
    def update
      @image = @animation[@frame_name]
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
      
      if @moving
        if leaving_screen?
          @parent.transition(@moving)
        elsif @undo_move or colliding_with_terrain?(@moving)
          @x, @y = @last_x, @last_y
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
      
      @moving = nil
      @undo_move = false
      @last_x, @last_y = @x, @y
    end
    

  end
end