module LD20
  class SwitchLockedDoor < ClosedDoor
    traits :bounding_box, :collision_detection
    def setup
      @image = Image["switch_locked_door.png"]
      @switch_id = @options[:switch_id]
      puts "Switch-locked Door: #{@switch_id} #{$window.dungeon.activated_switches}"
    end
    
    def update
      destroy if $window.dungeon.activated_switches.include? @switch_id
    end
    
    def open(switch_id)
      destroy if switch_id == @switch_id
    end
    
  end
  
  ClosedDoors << SwitchLockedDoor
  
end