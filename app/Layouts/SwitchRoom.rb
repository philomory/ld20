module LD20
  class SwitchRoom < RoomLayout
    @available_layouts = %w{nooks spiral}
    def setup
      @room_item = 'S'
    end
  end
end