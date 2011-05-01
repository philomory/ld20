module LD20
  class Prop::Switch < Prop
    def setup
      @switch_id = @options[:properties][:switch_id]
      @animations = Chingu::Animation.new(file: 'switch_32x32.png')
      @animations.frame_names = {inactive: 0..0, activating: 1..3, active: 3..7 }
      @state = $window.dungeon.activated_switches.include?(@switch_id) ? :active : :inactive
      @image = @animations[@state].next
      x, y = @options[:properties][:grid_x], @options[:properties][:grid_y]
      @parent.terrain[x,y] = [Floor1Covered,Floor2Covered].sample
    end
    
    def update
      @image = @animations[@state].next
      if @state == :activating && @animations[@state].last_frame?
        @state = :active
      end
    end
    
    def weapon_collision(weapon)
      if @state == :inactive
        activate
      end
    end
    
    def activate
      @state = :activating
      $window.dungeon.activated_switches << @switch_id
      SwitchLockedDoor.each {|d| d.open(@switch_id) }
    end
    
  end
end