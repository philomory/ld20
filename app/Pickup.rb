module LD20
  class Prop::Pickup < Prop
    
    def player_collision(player)
      self.picked_up_by(player)
      @sound.play if @sound
      destroy!
    end
    
    def self.create_small_pickup(x,y)
      klass = [HealthHeart].sample
      klass.create(:x => x, :y => y)
    end
    
  end
end