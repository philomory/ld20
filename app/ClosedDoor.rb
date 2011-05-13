module LD20
  ClosedDoors ||= []
  class ClosedDoor < Prop
    traits :bounding_box, :collision_detection
    
    def initialize(*args)
      super
      self.zorder ||= 501
      cache_bounding_box
    end
    
    def dir
      @options[:dir]
    end
    
    def player_collision(player)
      return true
    end
    def collided_with_enemy(enemy)
      enemy.undo_move
    end
    def collided_with_weapon(weapon)
      weapon.impacted
    end
  end
end