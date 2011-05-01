module LD20
  class SwitchLockedDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["switch_locked_door.png"]
      @switch_id = @options[:switch_id]
    end
    
  end
  
  ClosedDoors << SwitchLockedDoor
  
end