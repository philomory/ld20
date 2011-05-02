module LD20
  class BossRoom < RoomLayout
    @available_layouts = %w{boss_room}
    def populate(*args) 
      OldMan.create(x: BossX, y: BossY)
    end
    
    def start_by_doing
      text = {
        :text => "It was dangerous to come alone... take this!", 
        size: 20, 
        x: 128, 
        y: 240,
        zorder: Chingu::DEBUG_ZORDER + 1001,
        align: :center
      }
      popup = Chingu::GameStates::Popup.new(text: text)
      popup.instance_variable_set(:@color,Gosu::Color.new(100,0,0,0))
      $window.push_game_state(popup)
    end
  end
end
