module LD20
  class Prop::Lipstick < Prop::Pickup
    def setup
      @image = Image["lipstick.png"]
    end
    
    def picked_up_by(player)
      @x = @y = 0
      player.get_item(:lipstick,self)
    end
  end
end