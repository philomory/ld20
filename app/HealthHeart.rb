module LD20
  class Prop::HealthHeart < Prop::Pickup
    
    def setup
      @image = Image["health_heart.png"]
    end
    
    def picked_up_by(player)
      player.health += 1
    end
  end
  
  Props << Prop::Key
end