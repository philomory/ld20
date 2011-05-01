module LD20
  ClosedDoors = []
  class ClosedDoor < Chingu::GameObject
    def initialize(*args)
      super
      self.zorder ||= 501
    end
    
    def dir
      @options[:dir]
    end
    
    def player_collision(player)
      puts self.parent == $window.current_game_state
      return true
    end
    def collided_with_enemy(enemy)
      enemy.undo_move
    end
    def collided_with_other(object)
      object.hit_wall
    end
  end
end