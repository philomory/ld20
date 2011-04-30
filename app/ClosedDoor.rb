module LD20
  class ClosedDoor < Chingu::GameObject
    def initialize(*args)
      super
      self.zorder ||= 501
    end
    
    def collided_with_player(player)
      player.undo_move
    end
    def collided_with_enemy(enemy)
      enemy.undo_move
    end
    def collided_with_other(object)
      object.hit_wall
    end
  end
end