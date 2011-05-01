module LD20
  class SwitchRoom < RoomLayout
    @available_layouts = %w{nooks spiral}
    def setup
      @room_item = 'S'
    end
    
    def populate
      super([1,2,3,3])
    end
  end
end