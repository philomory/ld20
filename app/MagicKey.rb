module LD20
  class Prop::MagicKey < Prop::Pickup
    def setup
      @image = Image["magic_key.png"]
    end
    
    def picked_up_by(player)
      @x = @y = 0
      player.get_item(:magic_key,self)
    end
  end
end