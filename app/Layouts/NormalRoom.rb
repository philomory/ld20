module LD20
  class NormalRoom < RoomLayout
    @available_layouts = %w{blocks_a blocks_b center_block empty_room four_blocks horizontal_cover nooks vertical_cover}
    def populate
      super([0,1,2,2,3,3,3,4,5])
    end
  end
end