module LD20
  class KissHeart < Weapon
    traits :timer, :bounding_box, :collision_detection, :velocity
    include TerrainCollision
        
    def initialize(options = {})
      super
      @damage = 1
      @direction = options[:direction]

      @image = Image["kiss_heart.png"]
      
      @x, @y = options[:x], @options[:y]
      
      v = case @direction
      when :north then [ 0,-3,1,0]
      when :south then [ 0, 3,1,0]
      when :west  then [-3, 0,0,1]
      when :east  then [ 3, 0,0,1]
      end
      
      @x += v[0] * 5; @y += v[1] * 5
      
      @velocity_x, @velocity_y = v[0] + v[2], v[1] + v[3]; 
      
      every(150) do
        @velocity_x -= v[2] * 2
        @velocity_y -= v[3] * 2
        v[2] *= -1
        v[3] *= -1
      end
      
      cache_bounding_box
    end
    
    def breaks_blocks?
      true
    end
    
    def update
      if colliding_with_terrain?(@direction)
        destroy
      end
    end
    
    def impacted
      destroy
    end
    
    def collide_terrain_at_point?(x_pos,y_pos)
      !@parent.terrain_at(x_pos,y_pos).passes_projectiles 
    end
    
  end
end
