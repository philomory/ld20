module LD20
  class ItemBlockedSwitchRoom < RoomLayout
    @available_layouts = %w{nooks spiral}
    def setup
      @room_item = 'S'
      @item_blocked = 'B'
    end
    
    def populate
      super([1,2,3,3])
    end
  end
end