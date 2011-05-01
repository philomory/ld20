module LD20
  class KeyLockedDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["key_locked_door.png"]
    end
    
    def player_collision(player)
      if player.has_key?
        player.consume_key
        @parent.unlock_door(@options[:dir])
        self.destroy
        false
      else
        super
      end
    end
  end
  ClosedDoors << KeyLockedDoor
  
end