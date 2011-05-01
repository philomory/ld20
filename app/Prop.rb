module LD20
  Props = []
  class Prop < Chingu::GameObject
    traits :bounding_box, :collision_detection
    
    def self.place(options = {})
      @placed = true
      if self.class == Prop
        klass = self.const_get(options[:klass])
      else
        klass = self
      end
      options[:properties] ||= {}
      options[:properties][:grid_x] = options[:x]
      options[:properties][:grid_y] = options[:y]
      options[:x] *= TileWidth
      options[:x] += (TileWidth / 2)
      options[:y] *= TileHeight
      options[:y] += MapYOffset
      options[:y] += (TileHeight / 2)
      instance = klass.create(options)
      instance.build(options[:properties])
      instance
    end
    
    def build(options = {})
    end

    def player_collision(player)
    end
    
    def enemy_collision(enemy)
    end
    
    def weapon_collision(weapon)  
    end
    
    def destroy
      if @destroy_forever
        puts "Gone forever!"
        @parent.remove_layout_entry(@options[:properties][:grid_x],options[:properties][:grid_y])
      end
      super
    end
    alias :destroy! :destroy
    
  end
end