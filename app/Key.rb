module LD20
  class Prop::Key < Prop::Pickup
    
    def setup
      @image = Image["key.png"]
      @destroy_forever = true
    end
    
    def picked_up_by(player)
      player.get_key
    end
  end
  
  Props << Prop::Key
end