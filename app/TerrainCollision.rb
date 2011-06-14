module LD20
  module TerrainCollision
    
    #TODO: Remove this after completing expanded terrain interaction system.
    def colliding_with_terrain?(dir)
      box = self.bounding_box
      points = case dir
      when :west then [box.topleft, box.bottomleft]
      when :east then [box.topright, box.bottomright]
      when :north then [box.topleft, box.topright]
      when :south then [box.bottomleft, box.bottomright]
      end
      
      unwalkable = points.any? do |point|
        collide_terrain_at_point?(*point)
      end
      
      return unwalkable
      
    end
    
    def collide_terrain_at_point?(x_pos,y_pos)
      !@parent.terrain_at(x_pos,y_pos).walkable 
    end
    
    def leaving_screen?
      box = self.bounding_box
      case @moving
      when :west then (box.left <= 0)
      when :east then (box.right >= $window.width)
      when :north then (box.top <= MapYOffset)
      when :south then (box.bottom >= $window.height)
      end
    end
    
    def grid_x(x_pos)
      x_pos / TileWidth
    end
    
    def grid_y(y_pos)
      (y_pos - MapYOffset) / TileHeight
    end

    def entering_new_square?(dir)
      bbox = self.bounding_box
      case dir
      when :west  then grid_x(bbox.l) != grid_x(@old_bbox.l)
      when :east  then grid_x(bbox.r) != grid_x(@old_bbox.r)
      when :north then grid_y(bbox.t) != grid_y(@old_bbox.t)
      when :south then grid_y(bbox.b) != grid_y(@old_bbox.b)
      end
    end
    
    def center_terrain
      terrain_at(self.x,self.y)
    end
    
    def terrain_at(x_pos,y_pos)
      @parent.terrain[grid_x(x_pos),grid_y(y_pos)]
    end
    
    def terrain_on_edge(dir)
      box = self.bounding_box
      points = case dir
      when :west then [box.topleft, box.bottomleft]
      when :east then [box.topright, box.bottomright]
      when :north then [box.topleft, box.topright]
      when :south then [box.bottomleft, box.bottomright]
      end
      points.map {|p| terrain_at(*p) }
    end
    
    def prep_for_new_tick
      @old_x, @old_y = x, y
      @old_bbox = bounding_box
    end
    
  end
end