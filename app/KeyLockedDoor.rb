module LD20
  class KeyLockedDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["key_locked_door.png"]
    end
    
    def collided_with_player(player)
      if player.has_key?
        player.consume_key
        @parent.unlock_door(@options[:dir])
        self.destroy
      else
        super
      end
    end
  end
end