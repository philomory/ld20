module LD20
  class OldMan < Enemy
    include TerrainCollision
    
    def initialize(options ={})
      super
      @previous_x, @previous_y = @x, @y
      @health = 10
      @animations = Chingu::Animation.new(:file => "oldman_32x32.png",:bounce => true)
      @animations.frame_names = {happy: (0..0), moving: (1..4), casting: (5..5)}
      @current_style = :happy
      random_walk
      every(1000, name: :attack) { attack }
      update
    end
    
    def attack
      @moving = nil
      @current_style = :casting
      stop_timer(:rwalk)
      self.velocity_y = self.velocity_x = 0
      spell = case rand(3)
      when 0
        lambda {Knight.create}
      when 1,2
        lambda {Fireball.create(x: @x, y: @y + 16)}
      end
      after(75,&spell).then {random_walk}
    end
    
    
    def random_walk
      self.velocity_y = self.velocity_x = 0
      @moving = nil
      @current_style = :moving
      case rand(4)
      when 0
        @moving = :east
        self.velocity_x =  2
      when 1
        @moving = :west
        self.velocity_x = -2
      end
      after(250, name: :rwalk) {random_walk}
    end
    
    def hit_by(weapon)
      unprotect
      return if @invincible
      return if @hitby == weapon
      @invincible = true
      @hitby = weapon
      take_damage(weapon.damage)
      weapon.impacted
      return if dead?
      #Sound["enemy_ouch.ogg"].play
      self.color = 0x44FFFFFF
      self.mode = :additive
    end
    
    def unprotect
      after(50) do
        @invincible = false
        self.color = nil
        self.mode = :default
      end
    end
    
    def take_damage(amount)
      @health -= amount
      die if @health <= 0
    end
    
    def die
      @dead = true
      #Sound["enemy_dies.ogg"].play
      #Prop::Pickup.create_small_pickup(x,y) if rand(2).zero?
      destroy!
      @parent.win_boss_fight
    end
    
    def dead?
      @dead
    end
        
    def update
      @image = @animations[@current_style].next
      if @moving and colliding_with_terrain?(@moving)
        raise "Aha!" if [@previous_x, @previous_y].include?(nil)
        @x, @y = @previous_x, @previous_y
        @velocity_x = @velocity_y = 0
        stop_timer(:rwalk)
        random_walk
      end
    end
    
    
    
  end
end