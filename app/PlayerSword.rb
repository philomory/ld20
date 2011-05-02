module LD20
  class PlayerSword < Weapon
    traits :timer, :bounding_box, :collision_detection
    
    def initialize(options = {})
      super
      @direction = options[:direction]
      @damage = 2
      
      @animation = Chingu::Animation.new(:file => "sword_32x32.png")
      @animation.frame_names = {:north => 0, :south => 1, :west => 2, :east => 3 }
      @image = @animation[@direction]
      
      @x, @y = options[:x], @options[:y]
      
      move = case @direction
      when :north then [ 0,-2]
      when :south then [ 0, 2]
      when :west  then [-2, 0]
      when :east  then [ 2, 0]
      end
      
      @x += move[0] * 10; @y += move[1] * 10
      
      between(  0, 100) { @x += move[0]; @y += move[1] }
      between(150, 250) { @x -= move[0]; @y -= move[1] }
      .then { destroy! }
      
      cache_bounding_box
    end
    
  end
end
