module LD20
  class Prop::Breakable < Prop
    def build(properties = {})
      @properties = properties
      @image = Image['breakable.png']
      x, y = properties[:grid_x], properties[:grid_y]
      @parent.terrain[x,y] = Wall
    end
    
    def weapon_collision(weapon)
      if weapon.breaks_blocks?
        @parent.terrain[x,y] = [Floor1,Floor2].sample
        self.destroy
      else
        super
      end
    end
    
  end
end