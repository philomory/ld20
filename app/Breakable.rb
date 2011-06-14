module LD20
  class Prop::Breakable < ImpassibleProp
    def build(properties = {})
      @properties = properties
      @image = Image['breakable.png']
      x, y = properties[:grid_x], properties[:grid_y]
      @parent.terrain[x,y] = Floor1Covered
    end
    
    def weapon_collision(weapon)
      if weapon.breaks_blocks?
        x, y = @properties[:grid_x], @properties[:grid_y]
        @parent.terrain[x,y] = [Floor1,Floor2].sample
        self.destroy
      end
      super
    end
    
  end
end