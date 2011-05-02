module LD20
  class MagicKeyRoom < RoomLayout
    @available_layouts = %w{treasure_room}
    def populate(*args); end
    def setup
      Prop::MagicKey.create(x: WindowWidth/2, y: (WindowHeight + MapYOffset)/2) unless $window.basic_player.has_item?(:magic_key)
    end
  end
end