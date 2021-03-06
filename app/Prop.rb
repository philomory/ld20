module LD20
  Props = []
  class Prop < Chingu::GameObject
    traits :bounding_box, :collision_detection
    
    def self.place(options = {})
      @placed = true
      if self == Prop
        klass = Prop.const_get(options[:klass])
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
    
    def initialize(*args)
      raise "Prop is an abstract class!" if self.instance_of?(Prop)
      super
    end
    
    def build(options = {})
    end

    def player_collision(player)
    end
    
    def enemy_collision(enemy)
    end
    
    def weapon_collision(weapon)
      weapon.impacted  
    end
    
    def destroy
      if @destroy_forever
        @parent.remove_layout_entry(@options[:properties][:grid_x],options[:properties][:grid_y])
        if @options[:prize]
          @parent.room_data[:prize_collected] = true
        end
      end
      super
    end
    alias :destroy! :destroy
    
  end
end