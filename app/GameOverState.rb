module LD20
  class GameOverState < Chingu::GameState
    def initialize(options = {})
      super
      @white = Gosu::Color.new(255,255,255,255)
      @color = Gosu::Color.new(200,0,0,0)
      @font1 = Gosu::Font[40]
      @font2 = Font[20]
      @text1 = "GAME OVER"
      @text2 = "(to try again, press enter)"
      Song.current_song.stop if Song.current_song
      self.input = {:enter => :restart, :return => :restart}
    end

    def restart
      $window.restart
    end
  
    def draw
      previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
      $window.draw_quad(  0,0,@color,
                          $window.width,0,@color,
                          $window.width,$window.height,@color,
                          0,$window.height,@color, Chingu::DEBUG_ZORDER)
                        
      @font1.draw(@text1, ($window.width/2 - @font1.text_width(@text1)/2), $window.height/2 - @font1.height, Chingu::DEBUG_ZORDER + 1)
      @font2.draw(@text2, ($window.width/2 - @font2.text_width(@text2)/2), $window.height/2 + @font2.height, Chingu::DEBUG_ZORDER + 1)
    end
  end
end