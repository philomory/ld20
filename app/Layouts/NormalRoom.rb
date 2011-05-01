module LD20
  class NormalRoom < RoomLayout
    @available_layouts = %w{blocks_a blocks_b center_block empty_room four_blocks 
                            horizontal_cover nooks vertical_cover}
  end
end