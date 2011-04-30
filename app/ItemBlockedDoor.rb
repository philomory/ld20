module LD20
  class ItemBlockedDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["item_blocked_door.png"]
      @switch_id = @options[:switch_id]
    end
    
    def collided_with_other(object)
      if object.unblocks_doors?
        @parent.unlock_door(@options[:dir])
        self.destroy
      else
        super
      end
    end
    
  end
end