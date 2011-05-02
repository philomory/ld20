module LD20
  class KeyPrizeRoom < RoomLayout
    @available_layouts = %w{blocks_a blocks_b center_block empty_room four_blocks horizontal_cover vertical_cover}
    def setup
      @prize = {klass: "Key"}
      #puts "There's a prize here!"
    end
    
    def populate
      super([2,3,3,4,4,5])
    end
  end
end