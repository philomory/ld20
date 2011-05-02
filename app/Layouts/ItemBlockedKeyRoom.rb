module LD20
  class ItemBlockedKeyRoom < RoomLayout
    @available_layouts = %w{nooks spiral}
    def setup
      @room_item = 'K'
      @item_blocked = 'B'
    end
    
    def populate
      super([2,2,3])
    end
  end
end