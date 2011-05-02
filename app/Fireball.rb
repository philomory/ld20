module LD20
  class Fireball < Enemy
    include TerrainCollision
    
    def setup
      @image = Image["fireball.png"]
      @velocity_y = 8
      @velocity_x = rand(3) - 1
    end
    
    def update
      super
      if colliding_with_terrain?(:south)
        destroy
      end
    end
    
    def collide_terrain_at_point?(x_pos,y_pos)
      !@parent.terrain_at(x_pos,y_pos).passes_projectiles 
    end
    
    def hit_by(weapon)
      weapon.impacted
      destroy
    end
  end
end