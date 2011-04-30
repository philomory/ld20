module LD20
  class MagicDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["magic_door.png"]
    end
    
    def collided_with_player(player)
      if player.has_magic_key?
        @parent.unlock_door(@options[:dir])
        self.destroy
      else
        super
      end
    end
  end
end