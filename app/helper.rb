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