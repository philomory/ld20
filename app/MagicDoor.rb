module LD20
  class MagicDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["magic_door.png"]
    end
    
    def player_collision(player)
      if player.has_item?(:magic_key)
        @parent.unlock_door(@options[:dir])
        self.destroy
        false
      else
        super
      end
    end
  end
  
  ClosedDoors << MagicDoor
  
end