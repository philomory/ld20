module LD20
  class VictoryState < Chingu::GameState
    def initialize(options = {})
      super
      @white = Gosu::Color.new(255,255,255,255)
      @color = Gosu::Color.new(200,0,0,0)
      @font1 = Gosu::Font[25]
      @font2 = Font[15]
      @text1 = "THANKS PRINCESS, YOU'RE"
      @text1a = "THE HERO OF... THIS... PLACE."
      @text1b = "FINALLY,"
      @text1c = "PEACE RETURNS TO... HERE."
      @text1d = "THIS ENDS THE STORY."
      @text2 = "(to start another game, press enter)"
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
                        
      @font1.draw(@text1, ($window.width/2 - @font1.text_width(@text1)/2), $window.height/2 - 5 * @font1.height, Chingu::DEBUG_ZORDER + 1)
      @font1.draw(@text1a, ($window.width/2 - @font1.text_width(@text1a)/2), $window.height/2 - 3 * @font1.height, Chingu::DEBUG_ZORDER + 1)
      @font1.draw(@text1b, ($window.width/2 - @font1.text_width(@text1b)/2), $window.height/2 - @font1.height, Chingu::DEBUG_ZORDER + 1)
      @font1.draw(@text1c, ($window.width/2 - @font1.text_width(@text1c)/2), $window.height/2 + @font1.height, Chingu::DEBUG_ZORDER + 1)
      @font1.draw(@text1d, ($window.width/2 - @font1.text_width(@text1d)/2), $window.height/2 + 3 * @font1.height, Chingu::DEBUG_ZORDER + 1)
      
      @font2.draw(@text2, ($window.width/2 - @font2.text_width(@text2)/2), $window.height/2 + 3 * @font1.height + 2 * @font2.height, Chingu::DEBUG_ZORDER + 1)
    end
  end
end