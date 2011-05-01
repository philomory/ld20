module LD20
  class KeyRoom < RoomLayout
    @available_layouts = %w{nooks spiral}
    def setup
      @room_item = 'K'
    end
    
    def populate
      super([2,2,3])
    end
  end
end