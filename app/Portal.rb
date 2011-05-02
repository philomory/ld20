module LD20
  class Prop::Portal < Prop
    trait :bounding_box, :scale => 0.3

    def setup
      @image = Image["portal.png"]
    end
    
    def draw
      @base_image.draw_rot(@x, @y, @zorder, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode)  if @base_image
      super
    end
    
    def player_collision(player)
      @parent.boss_warp
    end
    
  end
end