module LD20
  class HUD < Chingu::BasicGameObject
    def initialize(options = {})
      super
      @player = options[:player] || @parent.player
      @font = Font[20]
    end
    
    def draw
      draw_health
      draw_sword
      draw_lipstick if @player.has_item? :lipstick
      draw_magic_key if @player.has_item? :magic_key
      draw_keys
    end
    
    def draw_sword
      Image['sword.png'].draw(0,0,0)
    end
    
    def draw_lipstick
      x = TileWidth
      Image['lipstick.png'].draw(x,0,0)
    end
    
    def draw_magic_key
      x = TileWidth * 2
      Image['magic_key.png'].draw(x,0,0)
    end
    
    def draw_keys
      x = 640 - (18 * 10) - (8 * 10)
      y = 8
      Image['key.png'].draw(x,y,0)
      @font.draw(" x #{@player.keys}",x + 16, y,1)
    end
    
    def draw_health
      x = 640 - (18 * 10)
      y = 8
      @player.health.times do
        Image["health_heart.png"].draw(x,y,0)
        x += 18
      end
      
      @player.damage_taken.times do
        Image["health_heart.png"].draw(x,y,0,1,1,0xFF888888)
        x += 18
      end
    end
    
    def visible
      true
    end
    
  end
end