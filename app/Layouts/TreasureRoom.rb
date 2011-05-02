module LD20
  class TreasureRoom < RoomLayout
    @available_layouts = %w{treasure_room}
    def populate(*args); end
    def setup
      Prop::Lipstick.create(x: WindowWidth/2, y: (WindowHeight + MapYOffset)/2) unless $window.basic_player.has_item?(:lipstick)
    end
  end
end
