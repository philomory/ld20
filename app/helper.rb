class Chingu::BasicGameObject
  #
  # Returns an array with all objects of current class.
  # BasicGameObject#all is state aware so only objects belonging to the current state will be returned.
  #
  #   Bullet.all.each do {}  # Iterate through all bullets in current game state
  #
  def self.all
    $window.current_scope.game_objects.of_class(self).dup 
  end
end

class Chingu::GameStates::Popup
  def button_up(id)
    def button_up(id)
      pop_game_state(:setup => false) if [Gosu::KbReturn, Gosu::KbEnter].include?(id)   # Return the previous game state, dont call setup()
    end
  end
end

# Fix chingu's rect off-by-one thing. A rect with height 32 should not cover 33 pixels!
class Chingu::Rect
  def right; return self.at(0)+self.at(2)-1; end
  alias r right
	
	def bottom; return self.at(1)+self.at(3)-1; end
  alias b bottom
	
end
